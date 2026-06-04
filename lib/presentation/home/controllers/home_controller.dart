import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/post/post_rank_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/load_recent_popular_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';

class HomeController extends GetxController with BaseHomeController {
  final RxList<PostRankEntity> recentPopularPostList = <PostRankEntity>[].obs;
  final List<PostEntity> _cachePostList = [];
  final List<UserEntity> _cacheProfileList = [];

  ///usecase 모음
  final LoadRecommendPostListUseCase loadRecommendPostsUseCase;
  final LoadRecommendUsersUseCase loadRecommendUsersUseCase;
  final UserSearchUseCase userSearchUseCase;
  final PostSearchUseCase postSearchUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final SavePostLikeLocalUseCase savePostLikeLocalUseCase;
  final GetCachedLikedPostIdsUseCase getCachedLikedPostIdsUseCase;
  final LoadRecentPopularPostListUseCase loadRecentPopularPostListUseCase;

  Set<int> _cachedLikedIds = {};

  final searchResultController = HomeSearchResultController();

  HomeController({
    required this.loadRecommendPostsUseCase,
    required this.loadRecommendUsersUseCase,
    required this.userSearchUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.savePostLikeLocalUseCase,
    required this.getCachedLikedPostIdsUseCase,
    required this.postSearchUseCase,
    required this.loadRecentPopularPostListUseCase,
  });

  bool isLast = false;

  @override
  void onInit() async {
    super.onInit();
    Get.put(searchResultController);
    _loadRecentPopularPostList();
    _loadRecommendPostList(refresh: true);
    loadRecommendUsers();
  }

  Future<void> _loadRecentPopularPostList() async {
    final result = await loadRecentPopularPostListUseCase();
    if (result.isEmpty) return;
    recentPopularPostList.assignAll(result);
    recentPopularPostList.sort(
      (a, b) => a.rank - b.rank,
    );
  }

  Future<void> _loadRecommendPostList({
    bool refresh = false,
    int size = 20,
  }) async {
    if (refresh) {
      _cachePostList.clear();
      isLast = false;
    }

    if (isLast) return;

    final result = await loadRecommendPostsUseCase.call(
      page: _cachePostList.length ~/ size,
      size: size,
    );
    isLast = result.last ?? true;

    // 로컬 캐시에 저장된 좋아요 누른 게시물 id 불러오기
    if (_cachedLikedIds.isEmpty && _cachePostList.isEmpty) {
      _cachedLikedIds = await getCachedLikedPostIdsUseCase();
    }

    // 로컬 캐시 기반으로 isFavorite 보정 (앱 재시작 후에도 유지)
    final applied = result.content.map((post) {
      if (_cachedLikedIds.contains(post.postId)) {
        return post.copyWith(isFavorite: true);
      }
      return post;
    }).toList();

    _cachePostList.addAll(applied);
    viewPostList.assignAll(_cachePostList);
  }


  bool isPostLiked(int postId) {
    return _cachedLikedIds.contains(postId);
  }

  Future<void> toggleLike(int postId, bool isLiked) async {

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
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        likeCount: _cachePostList[cacheIndex].likeCount + delta,
        isFavorite: isFavorite,
      );
    }
    viewPostList.assignAll(_cachePostList);
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

    final index = viewPostList.indexWhere(
          (p) => p.postId == postId,
    );

    if (index != -1) {
      final updatedPost =
      viewPostList[index].copyWith(
        likeCount: likeCount,
        isFavorite: isFavorite,
      );

      viewPostList[index] = updatedPost;


      viewPostList.refresh();
    }

    final cacheIndex =
    _cachePostList.indexWhere(
          (p) => p.postId == postId,
    );

    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] =
          _cachePostList[cacheIndex].copyWith(
            likeCount: likeCount,
            isFavorite: isFavorite,
          );
    }
  }

  Future<void> loadRecommendUsers() async {
    _cacheProfileList.clear();
    _cacheProfileList.addAll(await loadRecommendUsersUseCase.call());
    viewUserList.assignAll(_cacheProfileList);
  }

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
