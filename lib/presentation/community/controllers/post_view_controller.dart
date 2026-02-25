import 'package:get/get.dart';

class PostViewController extends GetxController {
  RxString title = "".obs;
  RxString authorName = "김유찬".obs;
  Rx<Duration> postAt = Duration(minutes: 4).obs;
  RxBool selectHeart = false.obs;
  RxBool selectBookMark = false.obs;
  RxList<String> postTags = <String>[].obs;
  RxString bodyText = "".obs;
  RxList<String> comments = <String>[].obs;
}
