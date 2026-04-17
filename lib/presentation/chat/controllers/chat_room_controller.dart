import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/presentation/chat/controllers/chat_review_controller.dart';
import 'package:ondo/presentation/chat/widgets/chat_review_dialog.dart';

class ChatController extends GetxController {
  final RxList<Chat> chats = <Chat>[].obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    chats.assignAll(_getChatList());
    super.onInit();
  }

  void sendChat(String comment) {
    //TODO : 채팅 전송 및, 채팅 리스트에 대화 내역 추가
    textController.clear();
    chats.add((comment: comment, isMe: true));
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

List<Chat> _getChatList() => <Chat>[
  (
    comment: "안녕하세요 UI/UX에 관심이 많으신 것 같아서 연락드려요! 혹시 조금만 이야기 가능할까요?",
    isMe: true,
  ),
  (comment: "네 당연히 가능하죠! 근데 제가 지금은 좀 바빠서 이따 다시 연락드려도 괜찮으실까요?", isMe: false),
];

typedef Chat = ({String comment, bool isMe});
