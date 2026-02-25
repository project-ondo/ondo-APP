import 'package:get/get.dart';

class CommunityFilterController extends GetxController {
  final List<String> tempTagListModel = <String>[
    "공부",
    "공부인증",
    "UIUX",
    "공부잘하는법",
    "FrontEnd",
  ];
  RxList<String> filterTags = <String>[].obs;

  @override
  void onInit() {
    loadFilterTagList();
    super.onInit();
  }

  void filterPosts (String filterString) {}

  void loadFilterTagList() {
    Set<String> temp = Set.from(filterTags);
    filterTags.value = (temp..addAll(tempTagListModel)).toList();
  }
}
