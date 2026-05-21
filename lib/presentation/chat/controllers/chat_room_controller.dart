import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/network/websocket/chat_stomp_client.dart';
import 'package:ondo/data/network/websocket/stomp_frame.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
import 'package:ondo/domain/usecases/chat/read_chat_message_use_case.dart';
import 'package:ondo/presentation/chat/states/chat_room_back_result.dart';
import 'package:ondo/presentation/chat/view_models/chat_message_view_model.dart';
import 'package:ondo/core/router/bindings/chat_rating_binding.dart';
import 'package:ondo/presentation/chat/widgets/chat_review_dialog.dart';

class ChatRoomController extends GetxController {
  final List<ChatMessageEntity> _cacheChatList = [];
  final RxList<ChatMessageViewModel> viewChatList =
      <ChatMessageViewModel>[].obs;
  final TextEditingController textController = TextEditingController();

  /// 상대방이 마지막으로 읽은 메시지 ID (읽음 이벤트 수신 시 갱신)
  final RxInt opponentLastReadMessageId = 0.obs;

  /// 상대방 타이핑 여부 (타이핑 이벤트 수신 시 갱신)
  final RxBool isOpponentTyping = false.obs;

  /// 상대방 온라인 여부 (프레즌스 이벤트 수신 시 갱신)
  final RxBool isOpponentOnline = false.obs;

  /// 상대방이 현재 이 채팅방을 보고 있는지 여부
  final RxBool isOpponentViewing = false.obs;

  final String chatRoomId;

  final LoadChatRoomMessageUseCase loadChatRoomMessageUseCase;
  final ReadChatMessageUseCase readChatMessageUseCase;
  final ChatStompClient stompClient;
  final AuthLocalDatasource authLocalDatasource;

  /// 내 publicId — 이벤트 본인 필터링에 사용
  String? _myPublicId;

  int lastMessageId = 0;

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
    required this.loadChatRoomMessageUseCase,
    required this.readChatMessageUseCase,
    required this.stompClient,
    required this.authLocalDatasource,
  });

  @override
  void onInit() {
    // 내 publicId 로드 → 메시지 내역 로드 → 읽음 처리 → WebSocket 구독 순서 보장
    authLocalDatasource.getMyPublicId().then((id) {
      _myPublicId = id;
      log('[ChatRoom] myPublicId: $_myPublicId');
    });
    _initLoadChatRoomMessages().then((_) {
      sendReadEvent();
      _connectAndEnter();
    });
    super.onInit();
  }

  @override
  void onClose() {
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
    super.onClose();
  }

  /// WebSocket 연결 → 채팅방 입장 이벤트 발행 → 메시지/읽음 토픽 구독 시작
  Future<void> _connectAndEnter() async {
    await stompClient.connect();

    // 채팅방 입장 이벤트 발행
    stompClient.publish(
      '/pub/chat.room.enter',
      body: jsonEncode({'chatRoomPublicId': chatRoomId}),
    );
    log('[ChatRoom] 채팅방 입장: $chatRoomId');

    // 메시지 토픽 구독 시작
    _messageSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId',
      _onMessageReceived,
    );
    log('[ChatRoom] 메시지 구독 시작: /topic/chat.rooms.$chatRoomId');

    // 읽음 이벤트 토픽 구독 시작
    _readSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.read',
      _onReadEventReceived,
    );
    log('[ChatRoom] 읽음 이벤트 구독 시작: /topic/chat.rooms.$chatRoomId.read');

    // 타이핑 이벤트 토픽 구독 시작
    _typingSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.typing',
      _onTypingEventReceived,
    );
    log('[ChatRoom] 타이핑 이벤트 구독 시작: /topic/chat.rooms.$chatRoomId.typing');

    // 프레즌스 이벤트 토픽 구독 시작
    _presenceSubscriptionId = stompClient.subscribe(
      '/topic/chat.rooms.$chatRoomId.presence',
      _onPresenceEventReceived,
    );
    log('[ChatRoom] 프레즌스 이벤트 구독 시작: /topic/chat.rooms.$chatRoomId.presence');
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
      final viewingChatRoomPublicId = json['viewingChatRoomPublicId'] as String?;
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
        final viewModel = ChatMessageViewModel.fromJson(json);
        viewChatList.insert(0, viewModel);
        log('[ChatRoom] 메시지 수신: $content');
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

  Future _initLoadChatRoomMessages() async {
    int? next = 0;
    while (next != null) {
      final res = await loadChatRoomMessageUseCase.call(
        chatRoomPublicId: chatRoomId,
        cursor: next,
        size: 10,
      );
      _cacheChatList.addAll(res.pages);
      next = res.nextCursor;
    }

    if (_cacheChatList.isNotEmpty) {
      viewChatList.assignAll(
        _cacheChatList.reversed.map(
          (e) => ChatMessageViewModel.fromJsonChatMessageEntity(e),
        ),
      );
      lastMessageId = _cacheChatList.last.messageId;
    }
  }

  /// 텍스트 메시지 전송
  ///
  /// - 빈 문자열이면 전송하지 않음
  /// - WebSocket으로 /pub/chat.send 발행
  /// - 내가 보낸 메시지 즉시 UI 반영 (isMe: true, messageId: null)
  /// - 서버 echo 수신 시 _onMessageReceived에서 messageId가 업데이트된다
  /// - IMAGE 타입은 추후 구현 예정
  void sendChat(String content) {
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

  Future backChatRoom() async {
    // WebSocket 읽음 이벤트 전송
    sendReadEvent();
    // HTTP 읽음 처리 유지
    Get.back<ChatRoomReadResult>(
      result: ChatRoomReadResult(
        success: await readChatMessageUseCase.call(chatRoomId, lastMessageId),
      ),
    );
  }

  Future quitChat() async {
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
}
