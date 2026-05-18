import 'dart:math';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/usecases/post/get_recommend_posts_usecase.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';

class HomeController extends GetxController {
  final RxList<HomeRecentPopularPostInfo> ranks =
      <HomeRecentPopularPostInfo>[].obs;
  final List<PostEntity> _cachePostList = [];
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;
  final RxList<UserEntity> viewUserList = <UserEntity>[].obs;
  final List<UserEntity> _cacheProfileList = [];

  ///usecase 모음
  final GetRecommendPostsUseCase recommendPostsUseCase;
  final LoadRecommendUsersUseCase recommendUsersUseCase;

  HomeController({
    required this.recommendPostsUseCase,
    required this.recommendUsersUseCase,
  });

  @override
  void onInit() async {
    super.onInit();
    //TODO : ranking 게시물 불러오기
    _sortRating(ranks..addAll(_getRanks()));
    await loadRecommendPosts();
    await loadRecommendUsers();
  }

  Future<void> loadRecommendPosts() async {
    _cachePostList.clear();
    //TODO : post 로직 변경
    //_cachePostList.addAll();
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
}

//TODO : 임시 데이터 삭제
typedef HomeRecentPopularPostInfo = ({
  int postId,
  String title,
  Duration creatAt,
  int favorites,
  bool isFavorite,
});
typedef HomeProfileInfo = ({String name, String skill, int rating});
typedef PostInfo = ({
  int postId,
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
      postId: i + 1,
      title: "요즘 공부 어케 하시나요 다들",
      creatAt: Duration(days: 3),
      favorites: 160 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
    (
      postId: i + 10,
      title: "10년차 개발자는 무슨 공부할까",
      creatAt: Duration(days: 5),
      favorites: 121 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
    (
      postId: i + 120,
      title: "팀장 퇴사해서 디자인빵꾸남",
      creatAt: Duration(days: 2),
      favorites: 73 * Random().nextInt(i),
      isFavorite: i % 2 == 0,
    ),
  },
];
