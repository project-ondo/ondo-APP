import 'package:get/get.dart';

class ChatReviewController extends GetxController {
  RxBool enableSubmit = false.obs;
  RxList<String> checkCategories = <String>[].obs;
  Rx<String?> detailReview = null.obs;
  RxInt star = 5.obs;

  void addCategory(String category) {
    checkCategories.addIf(!checkCategories.contains(category), category);
    checkEnableSubmit();
  }

  void removeCategory(String category) {
    checkCategories.remove(category);
    checkEnableSubmit();
  }

  void checkEnableSubmit() => enableSubmit.value = checkCategories.isNotEmpty;

  void setStar (int starIndex) => star.value = starIndex + 1;

  void setDetailReview (String review) => detailReview.value = review;

  void submit () {
    if(enableSubmit.value) {}
  }

}
