import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/rating/rating_chat_room_use_case.dart';

class ChatReviewController extends GetxController {
  final RxBool enableSubmit = false.obs;
  final RxSet<String> reviewTags = <String>{}.obs;
  final RxInt star = 5.obs;

  //TODO : error 처리 UI 반영
  RxString error = ''.obs;

  final TextEditingController commentController = TextEditingController();

  final DeleteChatRoomUseCase deleteChatRoomUseCase;
  final RatingChatRoomUseCase ratingChatRoomUseCase;
  final String chatRoomId;

  ChatReviewController({
    required this.deleteChatRoomUseCase,
    required this.chatRoomId,
    required this.ratingChatRoomUseCase,
  });

  Future<void> _deleteChatRoom() async {
    final res = await deleteChatRoomUseCase.call(chatRoomId);
    if (res != true) error.value = "DELETE_ERROR";
  }

  Future<void> _ratingChatRoom() async {
    if (star.value > 1 || star.value < 5) return;

    final res = await ratingChatRoomUseCase.call(
      chatRoomPublicId: chatRoomId,
      star: star.value,
      comment: commentController.text,
      tags: reviewTags.toList(),
    );
    if (res != true) error.value = "RATING_ERROR";
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

  Future submitReview() async {
    if (enableSubmit.value) {
      await _deleteChatRoom();
      await _ratingChatRoom();

      if (error.isEmpty) {
        Get.back<bool>(closeOverlays: true, result: true);
      }
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
