import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
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

  final String chatRoomId;

  final LoadChatRoomMessageUseCase loadChatRoomMessageUseCase;
  final ReadChatMessageUseCase readChatMessageUseCase;
  final ChatStompClient stompClient;

  int lastMessageId = 0;

  /// /topic/chat.rooms.{chatRoomPublicId} 구독 ID
  String? _messageSubscriptionId;

  /// /topic/chat.rooms.{chatRoomPublicId}.read 구독 ID
  String? _readSubscriptionId;

  ChatRoomController({
    required this.chatRoomId,
    required this.loadChatRoomMessageUseCase,
    required this.readChatMessageUseCase,
    required this.stompClient,
  });

  @override
  void onInit() {
    // 메시지 내역 로드 완료 후 읽음 처리 보장 (레이스 컨디션 방지)
    _initLoadChatRoomMessages().then((_) => sendReadEvent());
    _connectAndEnter();
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

  /// 읽음 이벤트 수신 핸들러
  ///
  /// Payload: { chatRoomPublicId, readerPublicId, lastReadMessageId, at }
  /// lastReadMessageId 이하의 내 메시지에 "읽음" 표시를 반영한다.
  void _onReadEventReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final readerPublicId = json['readerPublicId'] as String?;
      final lastReadMessageId = (json['lastReadMessageId'] as num?)?.toInt();
      log('[ChatRoom] 읽음 이벤트 수신: readerPublicId=$readerPublicId, lastReadMessageId=$lastReadMessageId');
      if (lastReadMessageId != null &&
          lastReadMessageId > opponentLastReadMessageId.value) {
        opponentLastReadMessageId.value = lastReadMessageId;
      }
    } catch (e) {
      log('[ChatRoom] 읽음 이벤트 파싱 실패: $e / body: ${frame.body}');
    }
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

  /// 실시간 메시지 수신 핸들러
  ///
  /// 수신 즉시 읽음 처리하여 상대방에게 읽음 상태 즉시 반영
  void _onMessageReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final viewModel = ChatMessageViewModel.fromJson(json);
      viewChatList.insert(0, viewModel);
      final receivedId = (json['messageId'] as num?)?.toInt();
      if (receivedId != null && receivedId > lastMessageId) {
        lastMessageId = receivedId;
      }
      log('[ChatRoom] 메시지 수신: ${viewModel.content}');
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
  /// - 내가 보낸 메시지 즉시 UI 반영 (isMe: true)
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
