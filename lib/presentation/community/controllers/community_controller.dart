import 'package:get/get.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

class CommunityController extends GetxController {
  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<PostInfo> _cachePosts = <PostInfo>[];
  final RxList<PostInfo> viewPosts = <PostInfo>[].obs;

  @override
  void onInit() {
    tags.addAll(_getTags());
    _cachePosts.addAll(_getPosts());
    viewPosts.addAll(_cachePosts);
    super.onInit();
  }

  @override
  void onReady() {
    Get.put(CommunityResultController());
    super.onReady();
  }

  void enterPostCreate() {
    Get.lazyPut(() => CommunityPostCreateController());
    Get.to(CommunityPostCreateScreen());
  }

  void searchPost(List<String> searchList) {
    //TODO: 커뮤니티 서버 검색 결과 반환
    final Set<PostInfo> result = {};
    result.addAllIf(
      searchList.isNotEmpty,
      _cachePosts.where(
        (post) =>
            searchList.any(
              (search) => post.title.contains(search),
            ) ||
            searchList.any(
              (search) => post.name.contains(search),
            ) ||
            searchList.any(
              (search) => post.skills.any(
                (skill) => skill.contains(search),
              ),
            ),
      ),
    );
    Get.find<CommunityResultController>().updateResult(result);
  }

  void filterPostTag(String tag, bool isSelect) {
    //TODO: 커뮤니티 서버 필터 검색 결과 반환
    isSelect ? selectTagList.add(tag) : selectTagList.remove(tag);
    if (selectTagList.isEmpty) {
      viewPosts.assignAll(_cachePosts);
      return;
    }
    final Set<PostInfo> result = {};
    result.addAll(
      _cachePosts.where(
        (post) =>
            selectTagList.any(
              (tag) => post.title.contains(tag),
            ) ||
            selectTagList.any(
              (tag) => post.name.contains(tag),
            ) ||
            selectTagList.any(
              (tag) => post.skills.any(
                (skill) => skill.contains(tag),
              ),
            ),
      ),
    );
    viewPosts.assignAll(result);
  }
}

class CommunityResultController extends GetxController {
  final RxList<PostInfo> viewPosts = <PostInfo>[].obs;

  void updateResult(Iterable<PostInfo> results) {
    viewPosts.assignAll(results);
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
    postId: i + 1,
      name: "김유찬",
      title: "요즘 UI UX",
      skills: ["UI/UX", "FrontEnd"],
      bookmarks: 12,
      favoites: 12,
      createAt: DateTime.now(),
      isFavorite: i % 2 == 0,
      isBookmark: i % 3 == 0,
    ),
  },
];
