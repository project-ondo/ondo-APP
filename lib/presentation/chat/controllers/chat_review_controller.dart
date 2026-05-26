import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/rating/rating_chat_room_use_case.dart';
import 'package:ondo/presentation/chat/states/chat_room_back_result.dart';

class ChatReviewController extends GetxController {
  final RxBool enableSubmit = false.obs;
  final RxBool isLoading = false.obs;
  final RxSet<String> reviewTags = <String>{}.obs;
  final RxInt star = 5.obs;

  final TextEditingController commentController = TextEditingController();

  final DeleteChatRoomUseCase deleteChatRoomUseCase;
  final RatingChatRoomUseCase ratingChatRoomUseCase;
  final String chatRoomId;

  ChatReviewController({
    required this.deleteChatRoomUseCase,
    required this.chatRoomId,
    required this.ratingChatRoomUseCase,
  });

  Future<bool> _deleteChatRoom() async {
    final res = await deleteChatRoomUseCase.call(chatRoomId);
    return res == true;
  }

  Future<bool> _ratingChatRoom() async {
    if (star.value < 1 || star.value > 5) return false;

    final res = await ratingChatRoomUseCase.call(
      chatRoomPublicId: chatRoomId,
      star: star.value,
      comment: commentController.text,
      tags: reviewTags.toList(),
    );
    return res == true;
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

  /// 별점 선택 (index: 0~4 → star: 1~5)
  void setStar(int index) => star.value = index + 1;

  Future submitReview() async {
    if (!enableSubmit.value || isLoading.value) return;

    isLoading.value = true;

    try {
      final deleteSuccess = await _deleteChatRoom();
      if (!deleteSuccess) {
        Get.snackbar(
          '오류',
          '채팅방 종료에 실패했습니다. 다시 시도해 주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 채팅방 삭제 성공 → 리뷰 전송 실패해도 이미 삭제됐으므로 무조건 화면 이탈
      final ratingSuccess = await _ratingChatRoom();
      if (!ratingSuccess) {
        Get.snackbar(
          '알림',
          '리뷰 전송에 실패했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      Get.back<ChatRoomQuitResult>(
        closeOverlays: true,
        result: ChatRoomQuitResult(success: true),
      );
    } catch (e) {
      Get.snackbar(
        '오류',
        '오류가 발생했습니다. 다시 시도해 주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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
