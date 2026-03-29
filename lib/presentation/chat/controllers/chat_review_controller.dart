import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatReviewController extends GetxController {
  final RxBool enableSubmit = false.obs;
  final RxSet<String> viewCategories = <String>{}.obs;
  final Rx<String> detailReview = "".obs;
  final RxInt star = 5.obs;

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    textController.addListener(() => setDetailReview(textController.text));
    super.onInit();
  }

  @override
  void onClose() {
    textController.removeListener(() => setDetailReview(textController.text));
    super.onClose();
  }

  void onCategoryChange(String category, bool isSelect) {
    isSelect ? viewCategories.add(category) : viewCategories.remove(category);
    checkEnableSubmit();
  }

  void checkEnableSubmit() => enableSubmit.value = viewCategories.isNotEmpty;

  set star(int index) => star.value = index + 1;

  void setDetailReview(String review) => detailReview.value = review;

  void submitReview() {}

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
