import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxBool isNewChat = true.obs;
  final RxList<Chat> chats = <Chat>[
    (
      comment: "안녕하세요 UI/UX에 관심이 많으신 것 같아서 연락드려요! 혹시 조금만 이야기 가능할까요?",
      isMe: true,
    ),
    (comment: "네 당연히 가능하죠! 근데 제가 지금은 좀 바빠서 이따 다시 연락드려도 괜찮으실까요?", isMe: false),
  ].obs;

  final TextEditingController textEditingController = TextEditingController();

  ChatController() {
    isNewChat.value = chats.isEmpty;
  }



  void addChats(Chat chat) => chats.add(chat);
}

typedef Chat = ({String comment, bool isMe});
