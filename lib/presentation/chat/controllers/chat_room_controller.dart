import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/data/network/websocket/chat_stomp_client.dart';
import 'package:ondo/data/network/websocket/stomp_frame.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
import 'package:ondo/domain/usecases/chat/read_chat_message_use_case.dart';
import 'package:ondo/presentation/chat/controllers/chat_review_controller.dart';
import 'package:ondo/presentation/chat/view_models/chat_message_view_model.dart';
import 'package:ondo/presentation/chat/widgets/chat_review_dialog.dart';

class ChatRoomController extends GetxController {
  final List<ChatMessageEntity> _cacheChatList = [];
  final RxList<ChatMessageViewModel> viewChatList =
      <ChatMessageViewModel>[].obs;
  final TextEditingController textController = TextEditingController();

  final String chatRoomId;

  final LoadChatRoomMessageUseCase loadChatRoomMessageUseCase;
  final ReadChatMessageUseCase readChatMessageUseCase;
  final ChatStompClient stompClient;

  int lastMessageId = 0;

  /// /topic/chat.rooms.{chatRoomPublicId} 구독 ID (onClose 시 해제)
  String? _messageSubscriptionId;

  ChatRoomController({
    required this.chatRoomId,
    required this.loadChatRoomMessageUseCase,
    required this.readChatMessageUseCase,
    required this.stompClient,
  });

  @override
  void onInit() {
    _initLoadChatRoomMessages();
    _connectAndEnter();
    super.onInit();
  }

  /// WebSocket 연결 → 채팅방 입장 이벤트 발행 → 메시지 토픽 구독 시작
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
  }

  /// 실시간 메시지 수신 핸들러
  ///
  /// 서버로부터 MESSAGE 프레임이 오면 호출됨.
  /// body를 파싱하여 [viewChatList] 끝에 추가.
  void _onMessageReceived(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final viewModel = ChatMessageViewModel.fromJson(json);
      viewChatList.add(viewModel);
      // 마지막 읽은 메시지 ID 갱신 (읽음 처리에 활용)
      lastMessageId = (json['messageId'] as num?)?.toInt() ?? lastMessageId;
      log('[ChatRoom] 메시지 수신: ${viewModel.content}');
    } catch (e) {
      log('[ChatRoom] 메시지 파싱 실패: $e / body: ${frame.body}');
    }
  }

  @override
  void onClose() {
    if (_messageSubscriptionId != null) {
      stompClient.unsubscribe(_messageSubscriptionId!);
      log('[ChatRoom] 메시지 구독 해제: $_messageSubscriptionId');
    }
    super.onClose();
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

  void sendChat(String content) {
    //TODO : 채팅 전송 및, 채팅 리스트에 대화 내역 추가
    textController.clear();
    //TODO : 전송 방식 또는 data 정의가 되면 필드 추가 및 정적 데이터 삭제
    viewChatList.add(
      ChatMessageViewModel(
        messageType: "TEXT",
        content: content,
        createdAt: DateTime.now(),
        isMe: true,
        profileImageKey: null,
      ),
    );
  }

  Future backChatRoom() async {
    Get.back<bool>(
      result: await readChatMessageUseCase.call(chatRoomId, lastMessageId),
    );
  }

  void quitChatRoom() {
    Get.dialog(
      CustomAlertDialog(
        title: "커피챗 종료",
        comment: "정말 커피챗을 종료하시겠어요?",
        actionLeft: () => Get.back(),
        actionRight: () {
          Get.lazyPut(
            () => ChatReviewController(
              deleteChatRoomUseCase: Get.find<DeleteChatRoomUseCase>(),
              chatRoomId: chatRoomId,
            ),
          );
          Get.back();
          Get.dialog(ChatReviewDialog());
        },
        rightActionText: "다음",
      ),
    );
  }
}
