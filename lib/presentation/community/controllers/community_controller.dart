import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

class CommunityController extends GetxController {
  RxList<String> filterTags = <String>[].obs;
  late final CommunitySearchResultController searchResultController;

  @override
  void onInit() {
    filterTags.addAll(_getTags());
    super.onInit();
  }

  @override
  void onReady() {
    searchResultController = Get.put(CommunitySearchResultController());
    super.onReady();
  }

  void filterPosts(String filterString) {}
}

class CommunitySearchResultController extends GetxController {
  List<PostInfo> posts = <PostInfo>[].obs;

  void searchResultInfo(String text) {
    //TODO: 커뮤니티 서버 검색 결과 반환
    if(text.isEmpty) posts.clear();
    posts.assignAll(_getPosts());
  }
}

List<String> _getTags() => [
  "공부",
  "공부인증",
  "UIUX",
  "공부잘하는법",
  "FrontEnd",
];

List<PostInfo> _getPosts() => [
  for (int i = 0; i < 8; i++) ...{
    (
      name: "김유찬",
      title: "요즘 UI UX",
      skills: ["UI/UX", "FrontEnd"],
      bookmarks: 12,
      favoites: 12,
      createAt: Duration(minutes: i),
      isFavorite: i % 2 == 0,
      isBookmark: i % 3 == 0,
    ),
  },
];
