import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/constants/report_type.dart';
import 'package:ondo/core/design_system/components/custom_report_dialog.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/network/websocket/chat_stomp_client.dart';
import 'package:ondo/data/network/websocket/stomp_frame.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
import 'package:ondo/domain/usecases/chat/read_chat_message_use_case.dart';
import 'package:ondo/domain/usecases/notification/show_local_notification_setting_use_case.dart';
import 'package:ondo/presentation/chat/states/chat_room_back_result.dart';
import 'package:ondo/presentation/chat/view_models/chat_message_view_model.dart';
import 'package:ondo/core/router/bindings/chat_rating_binding.dart';
import 'package:ondo/presentation/chat/widgets/chat_review_dialog.dart';

class ChatRoomController extends GetxController with WidgetsBindingObserver {
  final List<ChatMessageEntity> _cacheChatList = [];
  final RxList<ChatMessageViewModel> viewChatList =
      <ChatMessageViewModel>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  /// 상대방이 마지막으로 읽은 메시지 ID (읽음 이벤트 수신 시 갱신)
  final RxInt opponentLastReadMessageId = 0.obs;

  /// 상대방 타이핑 여부 (타이핑 이벤트 수신 시 갱신)
  final RxBool isOpponentTyping = false.obs;

  /// 상대방 온라인 여부 (프레즌스 이벤트 수신 시 갱신)
  final RxBool isOpponentOnline = false.obs;

  /// 상대방이 현재 이 채팅방을 보고 있는지 여부
  final RxBool isOpponentViewing = false.obs;

  final String chatRoomId;
  final String opponentDisplayName;
  final String? opponentProfileImageKey;
  final RxString opponentProfileImageUrl = ''.obs;

  final LoadChatRoomMessageUseCase loadChatRoomMessageUseCase;
  final ReadChatMessageUseCase readChatMessageUseCase;
  final ChatStompClient stompClient;
  final ShowLocalNotificationUseCase showLocalNotificationUseCase;
  final AuthLocalDatasource authLocalDatasource;
  final MediaRemoteDatasource mediaRemoteDatasource;

  /// 내 publicId — 이벤트 본인 필터링에 사용
  String? _myPublicId;

  int lastMessageId = 0;

  /// 컨트롤러 해제 여부 — 비동기 초기화 중 조기 이탈 시 작업 중단용
  bool _isDisposed = false;

  int? _nextCursor;
  bool _hasNext = false;
  bool _isLoadingMore = false;

  /// /topic/chat.rooms.{chatRoomPublicId} 구독 ID
  String? _messageSubscriptionId;

  /// /topic/chat.rooms.{chatRoomPublicId}.read 구독 ID
  String? _readSubscriptionId;

  /// /topic/chat.rooms.{chatRoomPublicId}.typing 구독 ID
  String? _typingSubscriptionId;

  /// /topic/chat.rooms.{chatRoomPublicId}.presence 구독 ID
  String? _presenceSubscriptionId;

  /// 타이핑 중지 감지용 디바운스 타이머 (2초 후 typing: false 전송)
  Timer? _typingTimer;

  /// sendChat()으로 전송했지만 아직 서버 echo를 받지 못한 메시지 내용 (순서 보장)
  ///
  /// echo 수신 시 로컬 메시지와 매칭하여 messageId를 업데이트하고 중복 삽입을 방지한다.
  final Queue<String> _pendingSentContents = Queue<String>();

  ChatRoomController({
    required this.chatRoomId,
    required this.opponentDisplayName,
    this.opponentProfileImageKey,
    required this.loadChatRoomMessageUseCase,
    required this.readChatMessageUseCase,
    required this.stompClient,
    required this.showLocalNotificationUseCase,
    required this.authLocalDatasource,
    required this.mediaRemoteDatasource,
  });

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    // 내 publicId 로드 → 프로필 이미지 → 메시지 내역 로드 → 읽음 처리 → WebSocket 구독 순서 보장
    _initializeController();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stompClient.pausePing();
      log('[ChatRoom] 앱 백그라운드 → Ping 중단');
    } else if (state == AppLifecycleState.resumed) {
      stompClient.resumePing();
      log('[ChatRoom] 앱 포그라운드 → Ping 재개');
    }
  }

  Future<void> _initializeController() async {
    try {
      // 1. 내 publicId 로드
      _myPublicId = await authLocalDatasource.getMyPublicId();
      if (_isDisposed) return;
      log('[ChatRoom] myPublicId: $_myPublicId');

      // 2. 상대방 프로필 이미지 URL 변환
      if (opponentProfileImageKey != null &&
          opponentProfileImageKey!.isNotEmpty) {
        try {
          final url = await mediaRemoteDatasource.getDownloadUrl(
            key: opponentProfileImageKey!,
          );
          if (_isDisposed) return;
          opponentProfileImageUrl.value = url;
        } catch (e) {
          log('[ChatRoom] 프로필 이미지 로드 실패: $e');
          if (_isDisposed) return;
          opponentProfileImageUrl.value = '';
        }
      }

      // 3. 메시지 내역 로드
      await _initLoadChatRoomMessages();
      if (_isDisposed) return;

      // 4. 읽음 처리 및 WebSocket 연결
      sendReadEvent();
      await _connectAndEnter();
    } catch (e) {
      log('[ChatRoom] 초기화 중 에러 발생: $e');
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    // reverse: true 환경에서 maxScrollExtent 근처 = 가장 오래된 메시지 쪽
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreMessages();
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    // 구독 해제
    if (_messageSubscriptionId != null) {
      stompClient.unsubscribe(_messageSubscriptionId!);
      log('[ChatRoom] 메시지 구독 해제: $_messageSubscriptionId');
    }
    if (_readSubscriptionId != null) {
      stompClient.unsubscribe(_readSubscriptionId!);
      log('[ChatRoom] 읽음 이벤트 구독 해제: $_readSubscriptionId');
    }
    if (_typingSubscriptionId != null) {
      stompClient.unsubscribe(_typingSubscriptionId!);
      log('[ChatRoom] 타이핑 이벤트 구독 해제: $_typingSubscriptionId');
    }
    if (_presenceSubscriptionId != null) {
      stompClient.unsubscribe(_presenceSubscriptionId!);
      log('[ChatRoom] 프레즌스 이벤트 구독 해제: $_presenceSubscriptionId');
    }
    // 타이핑 중이었다면 타이머 취소 후 typing: false 전송
    if (_typingTimer != null) {
      _typingTimer?.cancel();
      _typingTimer = null;
      sendTypingEvent(false);
    }
    // 모든 퇴장 시나리오에서 읽음 처리 보장 (뒤로가기 제스처 등 포함)
    sendReadEvent();
    // 채팅방 퇴장 이벤트 발행
    stompClient.publish(
      '/pub/chat.room.leave',
      body: jsonEncode({'chatRoomPublicId': chatRoomId}),
    );
    textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.onClose();
  }

  /// WebSocket 구독 등록 → 연결 → 채팅방 입장 이벤트 발행
  ///
  /// 구독을 connect() 보다 먼저 등록하여, 초기 연결 실패 시에도
  /// _subscriptions 맵에 정보가 보존되고 재연결 후 _resubscribeAll()로 복구된다.
  Future<void> _connectAndEnter() async {
    // 구독 먼저 등록 (연결 실패해도 맵에 보존 → 재연결 시 자동 복구)
    _messageSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId',
      _onMessageReceived,
    );
    log('[ChatRoom] 메시지 구독 등록: /topic/chat.rooms.$chatRoomId');

    _readSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.read',
      _onReadEventReceived,
    );
    log('[ChatRoom] 읽음 이벤트 구독 등록: /topic/chat.rooms.$chatRoomId.read');

    _typingSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.typing',
      _onTypingEventReceived,
    );
    log('[ChatRoom] 타이핑 이벤트 구독 등록: /topic/chat.rooms.$chatRoomId.typing');

    _presenceSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.presence',
      _onPresenceEventReceived,
    );
    log('[ChatRoom] 프레즌스 이벤트 구독 등록: /topic/chat.rooms.$chatRoomId.presence');

    // 연결 시도 — 실패해도 자동 재연결 예약됨
    try {
      await stompClient.connect();
    } catch (e) {
      log('[ChatRoom] STOMP 초기 연결 실패 → 자동 재연결 예약됨: $e');
      return;
    }

    // 연결 성공 시에만 입장 이벤트 발행
    stompClient.publish(
      '/pub/chat.room.enter',
      body: jsonEncode({'chatRoomPublicId': chatRoomId}),
    );
    log('[ChatRoom] 채팅방 입장: $chatRoomId');
  }

  /// 읽음 처리 이벤트 전송
  ///
  /// - lastMessageId가 0이면 전송하지 않음 (읽을 메시지 없음)
  /// - 채팅방 진입 시 및 나갈 때 호출
  void sendReadEvent() {
    if (lastMessageId == 0) return;

    stompClient.publish(
      '/pub/chat.read',
      body: jsonEncode({
        'chatRoomPublicId': chatRoomId,
        'lastReadMessageId': lastMessageId,
      }),
    );
    log('[ChatRoom] 읽음 처리 전송: lastMessageId=$lastMessageId');
  }

  /// 타이핑 이벤트 전송
  ///
  /// [typing] true: 입력 중, false: 입력 중지
  void sendTypingEvent(bool typing) {
    stompClient.publish(
      '/pub/chat.typing',
      body: jsonEncode({
        'chatRoomPublicId': chatRoomId,
        'typing': typing,
      }),
    );
    log('[ChatRoom] 타이핑 이벤트 전송: typing=$typing');
  }

  /// 텍스트 입력 변경 시 호출 — 타이핑 이벤트 디바운스 처리
  ///
  /// - 입력값이 비어있으면 즉시 typing: false 전송 (전송 버튼으로 메시지 전송 후 clear 포함)
  /// - 타이머가 없는 상태(최초 입력)에서만 typing: true 전송 (불필요한 트래픽 방지)
  /// - 2초간 추가 입력이 없으면 typing: false 자동 전송
  void onTypingChanged(String text) {
    if (text.isEmpty) {
      _typingTimer?.cancel();
      _typingTimer = null;
      sendTypingEvent(false);
      return;
    }

    if (_typingTimer == null) {
      sendTypingEvent(true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(
      const Duration(seconds: 2),
      () {
        sendTypingEvent(false);
        _typingTimer = null;
      },
    );
  }

  /// 타이핑 이벤트 수신 핸들러
  ///
  /// Payload: { chatRoomPublicId, userPublicId, typing, at }
  /// isOpponentTyping 상태를 갱신하여 UI 타이핑 인디케이터에 반영한다.
  /// 내가 보낸 타이핑 이벤트는 본인 필터링으로 무시한다.
  void _onTypingEventReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final userPublicId = json['userPublicId'] as String?;
      final typing = json['typing'] as bool? ?? false;
      log('[ChatRoom] 타이핑 이벤트 수신: userPublicId=$userPublicId, typing=$typing');
      // 내가 보낸 이벤트는 무시
      if (userPublicId != null && userPublicId == _myPublicId) return;
      isOpponentTyping.value = typing;
    } catch (e) {
      log('[ChatRoom] 타이핑 이벤트 파싱 실패: $e / body: ${frame.body}');
    }
  }

  /// 프레즌스 이벤트 수신 핸들러
  ///
  /// Payload: { userPublicId, online, viewingChatRoomPublicId, at }
  /// 상대방 온라인 여부 및 현재 이 채팅방 열람 여부를 갱신한다.
  /// 내가 발생시킨 프레즌스 이벤트는 본인 필터링으로 무시한다.
  void _onPresenceEventReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final userPublicId = json['userPublicId'] as String?;
      final online = json['online'] as bool? ?? false;
      final viewingChatRoomPublicId =
          json['viewingChatRoomPublicId'] as String?;
      log(
        '[ChatRoom] 프레즌스 이벤트 수신: userPublicId=$userPublicId, online=$online, viewing=$viewingChatRoomPublicId',
      );
      // 내가 발생시킨 이벤트는 무시
      if (userPublicId != null && userPublicId == _myPublicId) return;
      isOpponentOnline.value = online;
      isOpponentViewing.value = viewingChatRoomPublicId == chatRoomId;
    } catch (e) {
      log('[ChatRoom] 프레즌스 이벤트 파싱 실패: $e / body: ${frame.body}');
    }
  }

  /// 읽음 이벤트 수신 핸들러
  ///
  /// Payload: { chatRoomPublicId, readerPublicId, lastReadMessageId, at }
  /// lastReadMessageId 이하의 내 메시지에 "읽음" 표시를 반영한다.
  /// 내가 보낸 읽음 이벤트(본인 읽음)는 무시한다.
  void _onReadEventReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final readerPublicId = json['readerPublicId'] as String?;
      final lastReadMessageId = (json['lastReadMessageId'] as num?)?.toInt();
      log(
        '[ChatRoom] 읽음 이벤트 수신: readerPublicId=$readerPublicId, lastReadMessageId=$lastReadMessageId',
      );
      // 내가 보낸 읽음 이벤트는 무시 (상대방의 읽음만 반영)
      if (readerPublicId != null && readerPublicId == _myPublicId) return;
      if (lastReadMessageId != null &&
          lastReadMessageId > opponentLastReadMessageId.value) {
        opponentLastReadMessageId.value = lastReadMessageId;
      }
    } catch (e) {
      log('[ChatRoom] 읽음 이벤트 파싱 실패: $e / body: ${frame.body}');
    }
  }

  /// 실시간 메시지 수신 핸들러
  ///
  /// - 내가 보낸 메시지의 서버 echo인 경우: 로컬 메시지의 messageId를 갱신하고 중복 삽입을 방지
  /// - 상대방 메시지인 경우: 리스트 앞에 삽입 후 즉시 읽음 처리
  void _onMessageReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final receivedId = (json['messageId'] as num?)?.toInt();
      final content = json['content'] as String? ?? '';

      if (_pendingSentContents.isNotEmpty &&
          _pendingSentContents.first == content) {
        // 내가 보낸 메시지의 서버 echo → 로컬 메시지 messageId 업데이트
        _pendingSentContents.removeFirst();
        final localIndex = viewChatList.indexWhere(
          (vm) => vm.isMe && vm.messageId == null && vm.content == content,
        );
        if (localIndex != -1 && receivedId != null) {
          viewChatList[localIndex] = ChatMessageViewModel(
            messageId: receivedId,
            messageType: viewChatList[localIndex].messageType,
            content: content,
            createdAt: viewChatList[localIndex].createdAt,
            isMe: true,
            profileImageKey: null,
          );
          log('[ChatRoom] 로컬 메시지 messageId 업데이트: $receivedId');
        }
      } else {
        // 상대방 메시지 → 리스트 앞에 삽입
        final viewModel = ChatMessageViewModel.fromJson(
          json,
          myPublicId: _myPublicId,
        );
        viewChatList.insert(0, viewModel);
        log('[ChatRoom] 메시지 수신: $content');

        // 앱이 백그라운드 상태일 때 로컬 알림 발송
        final lifecycle = WidgetsBinding.instance.lifecycleState;
        if (lifecycle != AppLifecycleState.resumed) {
          showLocalNotificationUseCase.call(
            id: receivedId ?? DateTime.now().millisecondsSinceEpoch % 100000,
            title: '새 메시지',
            body: content,
          );
          log('[ChatRoom] 백그라운드 알림 발송: $content');
        }
      }

      if (receivedId != null && receivedId > lastMessageId) {
        lastMessageId = receivedId;
      }
      // 수신 즉시 읽음 처리 (채팅방에 머무는 동안 상대방에게 읽음 상태 반영)
      sendReadEvent();
    } catch (e) {
      log('[ChatRoom] 메시지 파싱 실패: $e / body: ${frame.body}');
    }
  }

  Future<void> _initLoadChatRoomMessages() async {
    final res = await loadChatRoomMessageUseCase.call(
      chatRoomPublicId: chatRoomId,
      cursor: 0,
      size: 50,
    );
    _cacheChatList.addAll(res.pages);
    _hasNext = res.hasNext;
    _nextCursor = res.nextCursor;

    if (_cacheChatList.isNotEmpty) {
      viewChatList.assignAll(
        _cacheChatList.map(
          (e) => ChatMessageViewModel.fromJsonChatMessageEntity(
            e,
            myPublicId: _myPublicId,
          ),
        ),
      );
      lastMessageId = _cacheChatList.first.messageId;
    }
  }

  /// 스크롤 상단 도달 시 이전 메시지 추가 로드
  Future<void> loadMoreMessages() async {
    if (!_hasNext || _nextCursor == null || _isLoadingMore) return;

    _isLoadingMore = true;
    try {
      final res = await loadChatRoomMessageUseCase.call(
        chatRoomPublicId: chatRoomId,
        cursor: _nextCursor!,
        size: 50,
      );
      _cacheChatList.addAll(res.pages);
      _hasNext = res.hasNext;
      _nextCursor = res.nextCursor;

      // assignAll 대신 addAll로 이전 메시지만 추가 — 실시간 수신 메시지 유실 방지
      viewChatList.addAll(
        res.pages.map(
          (e) => ChatMessageViewModel.fromJsonChatMessageEntity(
            e,
            myPublicId: _myPublicId,
          ),
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  /// 텍스트 메시지 전송
  ///
  /// - 빈 문자열이면 전송하지 않음
  /// - WebSocket으로 /pub/chat.send 발행
  /// - 내가 보낸 메시지 즉시 UI 반영 (isMe: true, messageId: null)
  /// - 서버 echo 수신 시 _onMessageReceived에서 messageId가 업데이트된다
  /// - IMAGE 타입은 추후 구현 예정
  void sendMessage(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    stompClient.publish(
      '/pub/chat.send',
      body: jsonEncode({
        'chatRoomPublicId': chatRoomId,
        'messageType': 'TEXT',
        'content': trimmed,
      }),
    );

    // pending 큐에 등록하여 서버 echo와 매칭
    _pendingSentContents.add(trimmed);

    viewChatList.insert(
      0,
      ChatMessageViewModel(
        messageType: 'TEXT',
        content: trimmed,
        createdAt: DateTime.now(),
        isMe: true,
        profileImageKey: null,
      ),
    );

    textController.clear();
  }

  Future<void> back() async {
    // WebSocket 읽음 이벤트 전송
    sendReadEvent();
    // HTTP 읽음 처리 유지
    Get.back<ChatRoomReadResult>(
      result: ChatRoomReadResult(
        success: await readChatMessageUseCase.call(chatRoomId, lastMessageId),
      ),
    );
  }

  Future<void> quit() async {
    Get.dialog(
      CustomAlertDialog(
        title: '커피챗 종료',
        comment: '정말 커피챗을 종료하시겠어요?',
        actionLeft: () => Get.back(),
        actionRight: () {
          Get.back();
          ChatRatingBinding(chatRoomId: chatRoomId).dependencies();
          Get.dialog(ChatReviewDialog());
        },
        rightActionText: '다음',
      ),
    );
  }

  void report(BuildContext context) => showDialog(
    context: context,
    builder: (context) =>
        CustomReportDialog(type: ReportType.chatRoom, targetId: chatRoomId),
  );
}
