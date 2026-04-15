import 'dart:math';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/home/recommend_post_entity.dart';
import 'package:ondo/domain/entities/home/recommend_user_entity.dart';
import 'package:ondo/domain/usecases/home/load_recommend_posts_use__case.dart';
import 'package:ondo/domain/usecases/home/load_recommend_users_use_case.dart';

class HomeController extends GetxController {
  final RxList<HomeRecentPopularPostInfo> ranks =
      <HomeRecentPopularPostInfo>[].obs;
  final List<PostEntity> _cachePostList = [];
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;
  final RxList<UserEntity> viewProfileList = <UserEntity>[].obs;
  final List<UserEntity> _cacheProfileList = [];

  final LoadRecommendPostsUseCase recommendPostsUseCase;
  final LoadRecommendUsersUseCase recommendUsersUseCase;

  HomeController({
    required this.recommendPostsUseCase,
    required this.recommendUsersUseCase,
  });

  @override
  void onInit() async {
    //TODO : ranking 게시물 불러오기
    _sortRating(ranks..addAll(_getRanks()));
    await loadRecommendPosts();
    await loadRecommendUsers();
    viewPostList.addAll(_cachePostList);
    viewProfileList.addAll(_cacheProfileList);
    super.onInit();
  }

  @override
  void onReady() {
    Get.put(HomeSearchResultController());
    super.onReady();
  }

  Future<void> loadRecommendPosts() async {
    _cachePostList.addAll(await recommendPostsUseCase.call());
  }

  Future<void> loadRecommendUsers() async {
    _cacheProfileList.addAll(await recommendUsersUseCase.call());
  }

  void _sortRating(RxList<HomeRecentPopularPostInfo>? list) => list == null
      ? ranks.sort((a, b) => (b.favorites - a.favorites))
      : list.sort((a, b) => b.favorites - a.favorites);

  void searchResultInfo(List<String> searchList) {
    final Set<UserEntity> profileResult = {};
    final Set<PostEntity> postResult = {};

    //TODO: 서버와의 연결에서 결과 가져오기
    profileResult.addAll(
      _cacheProfileList.where(
        (profile) =>
            searchList.any(
              (search) => profile.displayName.contains(search),
            ) ||
            searchList.any(
              (search) => profile.interests.contains(search),
            ),
      ),
    );

    //TODO: 서버와의 연결에서 결과 가져오기
    postResult.addAll(
      _cachePostList.where(
        (post) =>
            searchList.any(
              (search) => post.authorName.contains(search),
            ) ||
            searchList.any(
              (search) => post.title.contains(search),
            ) ||
            searchList.any(
              (search) => post.tags.any(
                (skill) => skill.contains(search),
              ),
            ),
      ),
    );

    Get.find<HomeSearchResultController>().updateResult(
      postResult,
      profileResult,
    );
  }
}

class HomeSearchResultController extends GetxController {
  final RxList<UserEntity> viewChatList = <UserEntity>[].obs;
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;

  void updateResult(
    Iterable<PostEntity> posts,
    Iterable<UserEntity> profiles,
  ) {
    viewChatList.assignAll(profiles);
    viewPostList.assignAll(posts);
  }
}

typedef HomeRecentPopularPostInfo = ({
  String title,
  Duration creatAt,
  int favorites,
  bool isFavorite,
});
typedef HomeProfileInfo = ({String name, String skill, int rating});
typedef PostInfo = ({
  List<String> skills,
  String title,
  String name,
  int favoites,
  int bookmarks,
  DateTime createAt,
  bool isBookmark,
  bool isFavorite,
});

List<HomeRecentPopularPostInfo> _getRanks() => [
  for (int i = 1; i < 5; i++) ...{
    (
      title: "요즘 공부 어케 하시나요 다들",
      creatAt: Duration(days: 3),
      favorites: 160 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
    (
      title: "10년차 개발자는 무슨 공부할까",
      creatAt: Duration(days: 5),
      favorites: 121 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
    (
      title: "팀장 퇴사해서 디자인빵꾸남",
      creatAt: Duration(days: 2),
      favorites: 73 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
  },
];

