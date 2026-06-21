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
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

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
  int _currentPage = 0;
  final RxBool isLoading = false.obs;

  bool _isUserLast = false;
  int _userCurrentPage = 0;
  final RxBool isLoadingUsers = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(searchResultController);
    _loadRecentPopularPostList();
    _loadRecommendPostList(refresh: true);
    loadRecommendUsers();

    ever(
      Get.find<PostController>().lastLikeEvent,
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
    try {
      final result = await loadRecentPopularPostListUseCase();
      if (result.isEmpty) return;
      recentPopularPostList.assignAll(result);
      recentPopularPostList.sort((a, b) => a.rank - b.rank);
    } catch (e) {
      debugPrint('[HomeController] 인기 게시물 조회 실패 - error: $e');
    }
  }

  Future<void> _loadRecommendPostList({
    bool refresh = false,
    int size = 20,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _cachePostList.clear();
      isLast = false;
    }

    if (isLast || isLoading.value) return;

    isLoading.value = true;
    try {
      final result = await loadRecommendPostsUseCase.call(
        page: _currentPage,
        size: size,
      );

      final applied = await Future.wait(
        result.content.map((post) async {
          return post.copyWith(
            isFavorite: await likedPostUseCase(post.postId),
          );
        }),
      );

      _cachePostList.addAll(applied);
      viewPostList.assignAll(_cachePostList);
      isLast = result.last ?? true;
      _currentPage++;
    } catch (e) {
      debugPrint('[HomeController] 추천 게시물 조회 실패 - error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() => _loadRecommendPostList();

  @override
  Future<void> refresh() async {
    await _loadRecommendPostList(refresh: true);
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    _updatePostLikeInList(postId, isLiked);

    try {
      if (isLiked) {
        await likePostUseCase(postId);
      } else {
        await unlikePostUseCase(postId);
      }
      await savePostLikeLocalUseCase(postId, isLiked);
    } catch (e) {
      debugPrint('[HomeController] 좋아요 토글 실패 - error: $e');
      _updatePostLikeInList(postId, !isLiked);
    }
  }

  void _updatePostLikeInList(int postId, bool isFavorite) {
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        likeCount: _cachePostList[cacheIndex].likeCount + (isFavorite ? 1 : -1),
        isFavorite: isFavorite,
      );
    }
    viewPostList.assignAll(_cachePostList);
  }

  Future<void> loadRecommendUsers() async {
    _userCurrentPage = 0;
    _isUserLast = false;
    _cacheProfileList.clear();
    await _fetchRecommendUsers();
  }

  Future<void> _fetchRecommendUsers() async {
    if (_isUserLast || isLoadingUsers.value) return;

    isLoadingUsers.value = true;
    try {
      final result = await loadRecommendUsersUseCase.call(
        page: _userCurrentPage,
        size: 10,
      );
      _cacheProfileList.addAll(result.content);
      viewUserList.assignAll(_cacheProfileList);
      _isUserLast = result.last ?? true;
      _userCurrentPage++;
    } catch (e) {
      debugPrint('[HomeController] 추천 유저 조회 실패 - error: $e');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> loadMoreUsers() => _fetchRecommendUsers();

  Future<void> search(String query) async {
    searchResultController._prepareNewSearch(query);
    searchResultController.isLoading.value = true;
    try {
      final userResult = await userSearchUseCase.call(
        keyword: query,
        page: 0,
        size: 20,
      );
      final postResult = await postSearchUseCase(
        keyword: query,
        sort: "latest",
        page: 0,
        size: 20,
      );
      searchResultController._appendResults(
        posts: postResult.content,
        users: userResult.content,
        isLast: postResult.last ?? true,
      );
    } catch (e) {
      debugPrint('[HomeController] 검색 실패 - error: $e');
    } finally {
      searchResultController.isLoading.value = false;
    }
  }

  Future<void> loadMoreSearchResults() async {
    if (!searchResultController.canLoadMore) return;

    searchResultController.isLoading.value = true;
    try {
      final postResult = await postSearchUseCase(
        keyword: searchResultController.currentQuery,
        sort: "latest",
        page: searchResultController.nextPostPage,
        size: 20,
      );
      searchResultController._appendResults(
        posts: postResult.content,
        users: const [],
        isLast: postResult.last ?? true,
      );
    } catch (e) {
      debugPrint('[HomeController] 검색 추가 로드 실패 - error: $e');
    } finally {
      searchResultController.isLoading.value = false;
    }
  }
}

class HomeSearchResultController extends GetxController with BaseHomeController {
  final List<PostEntity> _cachePostList = [];
  String _currentQuery = '';
  int _postCurrentPage = 0;
  final RxBool isLastPage = false.obs;
  final RxBool isLoading = false.obs;

  String get currentQuery => _currentQuery;
  int get nextPostPage => _postCurrentPage;
  bool get canLoadMore => !isLastPage.value && !isLoading.value;

  void _prepareNewSearch(String query) {
    _currentQuery = query;
    _postCurrentPage = 0;
    isLastPage.value = false;
    _cachePostList.clear();
    viewPostList.clear();
    viewUserList.clear();
  }


  void _appendResults({
    required List<PostEntity> posts,
    required List<UserEntity> users,
    required bool isLast,
  }) {
    _cachePostList.addAll(posts);
    viewPostList.assignAll(_cachePostList);
    if (users.isNotEmpty) viewUserList.assignAll(users);
    isLastPage.value = isLast;
    _postCurrentPage++;
  }
}