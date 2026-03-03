import 'dart:math';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<HomeRecentPopularPostInfo> ranks =
      <HomeRecentPopularPostInfo>[].obs;
  final RxList<HomeProfileInfo> chats = <HomeProfileInfo>[].obs;
  final RxList<PostInfo> posts = <PostInfo>[].obs;
  late final HomeSearchResultController searchResultController;

  @override
  void onInit() {
    _sortRating(ranks..addAll(_getRanks()));
    chats.addAll(_getChats());
    posts.addAll(_getPosts());
    super.onInit();
  }

  @override
  void onReady() {
    searchResultController = Get.put(HomeSearchResultController());
    super.onReady();
  }

  void _sortRating(RxList<HomeRecentPopularPostInfo>? list) => list == null
      ? ranks.sort((a, b) => (b.favorites - a.favorites))
      : list.sort((a, b) => b.favorites - a.favorites);
}

class HomeSearchResultController extends GetxController {
  final RxList<HomeProfileInfo> resultChats = <HomeProfileInfo>[].obs;
  final RxList<PostInfo> resultPosts = <PostInfo>[].obs;

  void searchResultInfo(String text) {
    //TODO: 서버와의 연결에서 결과 가져오기
    resultChats.assignAll(_getChats());
    resultPosts.assignAll(_getPosts());
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
  Duration createAt,
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

List<HomeProfileInfo> _getChats() => [
  for (int i = 1; i < 6; i++) ...{
    (name: "김유찬", skill: " UI/UX", rating: i),
  },
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
