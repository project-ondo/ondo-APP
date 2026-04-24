import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
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

  ChatRoomController({
    required this.chatRoomId,
    required this.loadChatRoomMessageUseCase,
  });

  @override
  void onInit() {
    _loadChatRoomMessages();
    super.onInit();
  }

  Future<void> _loadChatRoomMessages() async {
    //TODO : 정적 데이터 삭제
    final messages = await loadChatRoomMessageUseCase.call(
      chatRoomPublicId: chatRoomId,
      cursor: 0,
      size: 20,
    );
    _cacheChatList.assignAll(messages);
    viewChatList.assignAll(
      _cacheChatList.map(
        (e) => ChatMessageViewModel.fromJsonChatMessageEntity(e),
      ),
    );
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

  void showQuitAlert() {
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
