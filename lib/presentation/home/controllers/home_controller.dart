import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/usecases/home/load_recommend_posts_use_case.dart';
import 'package:ondo/domain/usecases/home/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';

class HomeController extends GetxController with BaseHomeController {
  final RxList<HomeRecentPopularPostInfo> ranks =
      <HomeRecentPopularPostInfo>[].obs;
  final List<PostEntity> _cachePostList = [];
  final List<UserEntity> _cacheProfileList = [];

  ///usecase 모음
  final LoadRecommendPostsUseCase recommendPostsUseCase;
  final LoadRecommendUsersUseCase recommendUsersUseCase;
  final UserSearchUseCase userSearchUseCase;
  final PostSearchUseCase postSearchUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final SavePostLikeLocalUseCase savePostLikeLocalUseCase;
  final GetCachedLikedPostIdsUseCase getCachedLikedPostIdsUseCase;

  Set<int> _cachedLikedIds = {};

  final searchResultController = HomeSearchResultController();

  HomeController({
    required this.recommendPostsUseCase,
    required this.recommendUsersUseCase,
    required this.userSearchUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.savePostLikeLocalUseCase,
    required this.getCachedLikedPostIdsUseCase,
    required this.postSearchUseCase,
  });

  @override
  void onInit() async {
    super.onInit();
    Get.put(searchResultController);
    //TODO : ranking 게시물 불러오기
    _sortRating(ranks..addAll(_getRanks()));
    _cachedLikedIds = await getCachedLikedPostIdsUseCase();
    await loadRecommendPosts();
    await loadRecommendUsers();
  }

  Future<void> loadRecommendPosts() async {
    _cachePostList.clear();
    final posts = await recommendPostsUseCase.call();

    // 로컬 캐시 기반으로 isFavorite 보정 (앱 재시작 후에도 유지)
    final applied = posts.map((post) {
      if (_cachedLikedIds.contains(post.postId)) {
        return post.copyWith(isFavorite: true);
      }
      // API가 이미 좋아요 상태를 반환한 경우 캐시에도 반영
      if (post.isFavorite) {
        _cachedLikedIds.add(post.postId);
      }
      return post;
    }).toList();

    _cachePostList.addAll(applied);
    viewPostList.assignAll(_cachePostList);
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    // 옵티미스틱 업데이트
    _updatePostLikeInList(postId, isLiked ? 1 : -1, isLiked);

    try {
      if (isLiked) {
        await likePostUseCase(postId);
      } else {
        await unlikePostUseCase(postId);
      }

      if (isLiked) {
        _cachedLikedIds.add(postId);
      } else {
        _cachedLikedIds.remove(postId);
      }
      await savePostLikeLocalUseCase(postId, isLiked);

      // 커뮤니티 목록과 cross-sync
      if (Get.isRegistered<CommunityController>()) {
        final post = viewPostList.firstWhereOrNull((p) => p.postId == postId);
        if (post != null) {
          Get.find<CommunityController>().updatePostLike(
            postId,
            post.likeCount,
            isLiked,
          );
        }
      }
    } catch (e) {
      debugPrint('[HomeController] 좋아요 토글 실패 - error: $e');
      _updatePostLikeInList(postId, isLiked ? -1 : 1, !isLiked);
    }
  }

  void _updatePostLikeInList(int postId, int delta, bool isFavorite) {
    final index = viewPostList.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      viewPostList[index] = viewPostList[index].copyWith(
        likeCount: viewPostList[index].likeCount + delta,
        isFavorite: isFavorite,
      );
      viewPostList.refresh();
    }
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        likeCount: _cachePostList[cacheIndex].likeCount + delta,
        isFavorite: isFavorite,
      );
    }
  }

  void updatePostLike(
    int postId,
    int likeCount,
    bool isFavorite,
  ) {
    if (isFavorite) {
      _cachedLikedIds.add(postId);
    } else {
      _cachedLikedIds.remove(postId);
    }


    final index = viewPostList.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      viewPostList[index] = viewPostList[index].copyWith(
        likeCount: likeCount,
        isFavorite: isFavorite,
      );
      viewPostList.refresh();
    }
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        likeCount: likeCount,
        isFavorite: isFavorite,
      );
    }
  }

  Future<void> loadRecommendUsers() async {
    _cacheProfileList.clear();
    _cacheProfileList.addAll(await recommendUsersUseCase.call());
    viewUserList.assignAll(_cacheProfileList);
  }

  void _sortRating(RxList<HomeRecentPopularPostInfo>? list) => list == null
      ? ranks.sort((a, b) => (b.favorites - a.favorites))
      : list.sort((a, b) => b.favorites - a.favorites);

  void search(String query) async {
    final Set<UserEntity> userRes = {};

    ///서버 유저 검색 api에서 user결과 실시간 표시
    // TODO 구조 변경
    userRes.addAll(
      await userSearchUseCase.call(keyword: query),
    );

    final postResult = await postSearchUseCase(
      keyword: query,
      sort: "latest",
    );

    ///홈 검색 결과 표시 controller
    searchResultController.updateResult(
      postResult.content,
      userRes,
    );
  }
}

class HomeSearchResultController extends GetxController
    with BaseHomeController {
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
