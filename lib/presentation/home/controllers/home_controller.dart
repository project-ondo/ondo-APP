import 'dart:math';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/usecases/home/load_recommend_posts_use_case.dart';
import 'package:ondo/domain/usecases/home/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';

class HomeController extends GetxController {
  final RxList<HomeRecentPopularPostInfo> ranks =
      <HomeRecentPopularPostInfo>[].obs;
  final List<PostEntity> _cachePostList = [];
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;
  final RxList<UserEntity> viewUserList = <UserEntity>[].obs;
  final List<UserEntity> _cacheProfileList = [];

  ///usecase 모음
  final LoadRecommendPostsUseCase recommendPostsUseCase;
  final LoadRecommendUsersUseCase recommendUsersUseCase;
  final UserSearchUseCase userSearchUseCase;

  final searchResultController = HomeSearchResultController();

  HomeController({
    required this.recommendPostsUseCase,
    required this.recommendUsersUseCase,
    required this.userSearchUseCase,
  });

  @override
  void onInit() async {
    super.onInit();
    Get.put(searchResultController);
    //TODO : ranking 게시물 불러오기
    _sortRating(ranks..addAll(_getRanks()));
    await loadRecommendPosts();
    await loadRecommendUsers();
  }

  Future<void> loadRecommendPosts() async {
    _cachePostList.clear();
    _cachePostList.addAll(await recommendPostsUseCase.call());
    viewPostList.assignAll(_cachePostList);
  }

  Future<void> loadRecommendUsers() async {
    _cacheProfileList.clear();
    _cacheProfileList.addAll(await recommendUsersUseCase.call());
    viewUserList.assignAll(_cacheProfileList);
  }

  void _sortRating(RxList<HomeRecentPopularPostInfo>? list) => list == null
      ? ranks.sort((a, b) => (b.favorites - a.favorites))
      : list.sort((a, b) => b.favorites - a.favorites);

  void search({required String query, required List<String> tags}) async {
    final Set<UserEntity> userRes = {};
    final Set<PostEntity> postRes = {};

    ///서버 유저 검색 api에서 user결과 실시간 표시
    userRes.addAll(
      await userSearchUseCase.call(interests: tags, keyword: query),
    );

    //TODO : 서버 게시물 검색 api 개발 이후 구현

    ///홈 검색 결과 표시 controller
    searchResultController.updateResult(
      postRes,
      userRes,
    );
  }
}

class HomeSearchResultController extends GetxController {
  final RxList<UserEntity> viewUserList = <UserEntity>[].obs;
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;

  ///홈 검색 결과 업데이트
  void updateResult(
    Iterable<PostEntity> posts,
    Iterable<UserEntity> profiles,
  ) {
    viewUserList.assignAll(profiles);
    viewPostList.assignAll(posts);
  }
}

//TODO : 임시 데이터 삭제
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
