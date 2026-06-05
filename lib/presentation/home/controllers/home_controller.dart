import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/post/post_rank_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/load_recent_popular_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';
import 'package:ondo/presentation/community/controllers/like_state_controller.dart';
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';

class HomeController extends GetxController with BaseHomeController {
  final RxList<PostRankEntity> recentPopularPostList = <PostRankEntity>[].obs;
  final List<PostEntity> _cachePostList = [];
  final List<UserEntity> _cacheProfileList = [];

  final LoadRecommendPostListUseCase loadRecommendPostsUseCase;
  final LoadRecommendUsersUseCase loadRecommendUsersUseCase;
  final UserSearchUseCase userSearchUseCase;
  final PostSearchUseCase postSearchUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final SavePostLikeLocalUseCase savePostLikeLocalUseCase;
  final LikedPostUseCase likedPostUseCase;
  final LoadRecentPopularPostListUseCase loadRecentPopularPostListUseCase;

  final searchResultController = HomeSearchResultController();

  HomeController({
    required this.loadRecommendPostsUseCase,
    required this.loadRecommendUsersUseCase,
    required this.userSearchUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.savePostLikeLocalUseCase,
    required this.likedPostUseCase,
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

    ever(
      Get.find<LikeStateController>().lastEvent,
          (event) {
        if (event == null) return;
        _syncLike(event.postId, event.isLiked, event.likeCount);
      },
    );
  }

  void _syncLike(int postId, bool isLiked, int likeCount) {
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        likeCount: likeCount,
        isFavorite: isLiked,
      );
      viewPostList.assignAll(_cachePostList);
    }
  }

  Future<void> _loadRecentPopularPostList() async {
    final result = await loadRecentPopularPostListUseCase();
    if (result.isEmpty) return;
    recentPopularPostList.assignAll(result);
    recentPopularPostList.sort((a, b) => a.rank - b.rank);
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

    final applied = await Future.wait(
      result.content.map((post) async {
        return post.copyWith(
          isFavorite: await likedPostUseCase(post.postId),
        );
      }),
    );

    _cachePostList.addAll(applied);
    viewPostList.assignAll(_cachePostList);
  }

  @override
  Future<void> refresh() async {
    await _loadRecommendPostList(refresh: true);
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    _updatePostLikeInList(postId, isLiked ? 1 : -1, isLiked);

    try {
      if (isLiked) {
        await likePostUseCase(postId);
      } else {
        await unlikePostUseCase(postId);
      }
      await savePostLikeLocalUseCase(postId, isLiked);
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

  Future<void> loadRecommendUsers() async {
    _cacheProfileList.clear();
    _cacheProfileList.addAll(await loadRecommendUsersUseCase.call());
    viewUserList.assignAll(_cacheProfileList);
  }

  void search(String query) async {
    final Set<UserEntity> userRes = {};

    userRes.addAll(
      await userSearchUseCase.call(keyword: query),
    );

    final postResult = await postSearchUseCase(
      keyword: query,
      sort: "latest",
    );

    searchResultController.updateResult(
      postResult.content,
      userRes,
    );
  }
}

class HomeSearchResultController extends GetxController
    with BaseHomeController {
  void updateResult(
      Iterable<PostEntity> posts,
      Iterable<UserEntity> profiles,
      ) {
    viewUserList.assignAll(profiles);
    viewPostList.assignAll(posts);
  }
}