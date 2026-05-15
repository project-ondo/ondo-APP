import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';

class ChatReviewController extends GetxController {
  final RxBool enableSubmit = false.obs;
  final RxSet<String> reviewTags = <String>{}.obs;
  final RxInt star = 5.obs;

  //TODO : error 처리 UI 반영
  RxString error = ''.obs;

  final TextEditingController commentController = TextEditingController();

  final DeleteChatRoomUseCase deleteChatRoomUseCase;
  final String chatRoomId;

  ChatReviewController({
    required this.deleteChatRoomUseCase,
    required this.chatRoomId,
  });

  Future<void> _deleteChatRoom() async {
    final res = await deleteChatRoomUseCase.call(chatRoomId);
    if (res != true) error.value = "DELETE_ERROR";
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void selectReviewTag(String tag, bool isSelect) {
    isSelect ? reviewTags.add(tag) : reviewTags.remove(tag);
    checkEnableSubmit();
  }

  void checkEnableSubmit() => enableSubmit.value = reviewTags.isNotEmpty;

  set star(int index) => star.value = index + 1;

  Future<void> submitReview() async {
    await _deleteChatRoom();
    //TODO : 채팅방 평점 등록 api 연결

    if (error.isEmpty) {
      Get.back<num>(closeOverlays: true, result: -1);
    }
  }

  final List<String> baseCategories = [
    "질문에 대한 답변이 빨라요",
    "친절해요",
    "예의있어요",
    "매너가 좋아요",
    "잘 들어줘요",
    "상세하게 설명해줘요",
    "저를 존중해줘요",
    "신뢰할 수 있는 정보를 주었어요",
  ];
}
