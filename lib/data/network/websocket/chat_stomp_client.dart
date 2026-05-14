import 'dart:async';
import 'dart:developer';

import 'package:ondo/core/env.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/network/websocket/stomp_frame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ignore_for_file: unused_field

/// STOMP over WebSocket 클라이언트
///
/// 역할:
/// - JWT 인증 헤더를 포함한 STOMP CONNECT 처리
/// - 토픽 구독(subscribe) / 발행(publish) 관리
/// - 연결 실패 시 자동 재연결 (최대 [_maxReconnectAttempts]회)
/// - 앱 포그라운드/백그라운드에 따른 Ping 일시 중단/재개
class ChatStompClient {
  final AuthLocalDatasource _localDatasource;

  ChatStompClient({required AuthLocalDatasource localDatasource})
      : _localDatasource = localDatasource;

  // ─── WebSocket ────────────────────────────────────────
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;
  bool _isConnected = false;
  Completer<void>? _connectCompleter;

  bool get isConnected => _isConnected;

  // ─── 구독 관리 ─────────────────────────────────────────
  /// subscriptionId → callback
  final Map<String, void Function(StompFrame)> _subscriptions = {};
  int _subscriptionCounter = 0;

  // ─── 재연결 ───────────────────────────────────────────
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectInterval = Duration(seconds: 3);

  // ─── Ping ─────────────────────────────────────────────
  Timer? _pingTimer;
  bool _isPaused = false;
  static const Duration _pingInterval = Duration(seconds: 30);

  // ─── Public API ───────────────────────────────────────

  /// WebSocket 연결 및 STOMP CONNECT 전송
  ///
  /// 서버로부터 CONNECTED 프레임을 수신할 때까지 await.
  /// 이미 연결된 경우 즉시 반환.
  /// 토큰이 없으면 연결하지 않음.
  Future<void> connect() async {
    if (_isConnected) return;

    final token = await _localDatasource.getAccessToken();
    if (token == null) {
      log('[STOMP] 토큰 없음 → 연결 취소');
      return;
    }

    try {
      final wsUrl = Env.wsBaseUrl;
      log('[STOMP] 연결 시도: $wsUrl');

      _connectCompleter = Completer<void>();

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _streamSubscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _sendFrame(StompFrame(
        command: 'CONNECT',
        headers: {
          'accept-version': '1.1,1.2',
          'Authorization': 'Bearer $token',
        },
      ));
      log('[STOMP] CONNECT 프레임 전송');

      // CONNECTED 수신까지 대기
      await _connectCompleter!.future;
    } catch (e) {
      log('[STOMP] 연결 실패: $e');
      _connectCompleter = null;
      _scheduleReconnect();
    }
  }

  /// 토픽 구독
  ///
  /// [destination] 예: `/topic/chat.rooms.{chatRoomPublicId}`
  /// 반환값: subscriptionId (unsubscribe 시 사용)
  String subscribe(String destination, void Function(StompFrame) onFrame) {
    final id = 'sub-${_subscriptionCounter++}';
    _subscriptions[id] = onFrame;

    _sendFrame(StompFrame(
      command: 'SUBSCRIBE',
      headers: {
        'destination': destination,
        'id': id,
      },
    ));
    log('[STOMP] SUBSCRIBE → $destination (id: $id)');
    return id;
  }

  /// 구독 해제
  void unsubscribe(String subscriptionId) {
    _subscriptions.remove(subscriptionId);
    _sendFrame(StompFrame(
      command: 'UNSUBSCRIBE',
      headers: {'id': subscriptionId},
    ));
    log('[STOMP] UNSUBSCRIBE → id: $subscriptionId');
  }

  /// 메시지 발행
  ///
  /// [destination] 예: `/pub/chat.send`
  /// [body] JSON 문자열. null이면 바디 없음.
  void publish(String destination, {String? body}) {
    if (!_isConnected) {
      log('[STOMP] 연결 안 됨 → publish 무시: $destination');
      return;
    }
    _sendFrame(StompFrame(
      command: 'SEND',
      headers: {
        'destination': destination,
        if (body != null) 'content-type': 'application/json',
      },
      body: body,
    ));
    log('[STOMP] SEND → $destination');
  }

  /// 연결 해제 및 모든 상태 초기화
  void disconnect() {
    _stopPing();
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;

    if (_isConnected) {
      _sendFrame(StompFrame(command: 'DISCONNECT'));
    }

    _streamSubscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _subscriptions.clear();
    log('[STOMP] 연결 해제 완료');
  }

  /// 앱 백그라운드 진입 시 호출 → Ping 중단
  void pausePing() {
    _isPaused = true;
    _stopPing();
    log('[STOMP] Ping 일시 중단 (백그라운드)');
  }

  /// 앱 포그라운드 복귀 시 호출 → Ping 재개 (필요 시 재연결)
  void resumePing() {
    _isPaused = false;
    if (_isConnected) {
      _startPing();
    } else {
      log('[STOMP] 포그라운드 복귀 → 재연결 시도');
      connect();
    }
    log('[STOMP] Ping 재개 (포그라운드)');
  }

  // ─── 내부 ─────────────────────────────────────────────

  void _sendFrame(StompFrame frame) {
    _channel?.sink.add(frame.serialize());
  }

  void _onMessage(dynamic raw) {
    if (raw is! String) return;

    final frame = StompFrame.parse(raw);
    if (frame == null) return; // heartbeat

    log('[STOMP] 수신: ${frame.command}');

    switch (frame.command) {
      case 'CONNECTED':
        _isConnected = true;
        _reconnectAttempts = 0;
        if (!_isPaused) _startPing();
        _connectCompleter?.complete();
        _connectCompleter = null;
        log('[STOMP] 연결 성공');

      case 'MESSAGE':
        final subId = frame.headers['subscription'];
        if (subId != null) {
          _subscriptions[subId]?.call(frame);
        }

      case 'ERROR':
        log('[STOMP] 서버 에러: ${frame.headers} / ${frame.body}');
    }
  }

  void _onError(Object error) {
    log('[STOMP] WebSocket 에러: $error');
    _isConnected = false;
    _stopPing();
    _scheduleReconnect();
  }

  void _onDone() {
    log('[STOMP] WebSocket 연결 종료');
    _isConnected = false;
    _stopPing();
    if (!_isPaused) _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log('[STOMP] 최대 재연결 횟수($_maxReconnectAttempts) 초과 → 중단');
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectInterval, () {
      _reconnectAttempts++;
      log('[STOMP] 재연결 시도 $_reconnectAttempts/$_maxReconnectAttempts');
      connect();
    });
  }

  void _startPing() {
    _stopPing();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      publish('/pub/chat.ping');
      log('[STOMP] Ping 전송');
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }
}
