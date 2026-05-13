import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
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

  int lastMessageId = 0;

  ChatRoomController({
    required this.chatRoomId,
    required this.loadChatRoomMessageUseCase,
    required this.readChatMessageUseCase,
  });

  @override
  void onInit() {
    _initLoadChatRoomMessages();
    super.onInit();
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
          Get.lazyPut(() => ChatReviewController());
          Get.back();
          Get.dialog(ChatReviewDialog());
        },
        rightActionText: "다음",
      ),
    );
  }
}
