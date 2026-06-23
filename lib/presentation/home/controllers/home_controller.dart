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
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmarked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_bookmark_local_use_case.dart';
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
  final BookmarkPostUseCase bookmarkPostUseCase;
  final UnbookmarkPostUseCase unbookmarkPostUseCase;
  final SavePostBookmarkLocalUseCase savePostBookmarkLocalUseCase;
  final BookmarkedPostUseCase bookmarkedPostUseCase;
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
    required this.bookmarkPostUseCase,
    required this.unbookmarkPostUseCase,
    required this.savePostBookmarkLocalUseCase,
    required this.bookmarkedPostUseCase,
    required this.postSearchUseCase,
    required this.loadRecentPopularPostListUseCase,
  });

  bool isLast = false;
  int _currentPage = 0;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isLoadingRanks = false.obs;
  final RxString rankErrorMessage = ''.obs;

  bool _isUserLast = false;
  int _userCurrentPage = 0;
  final RxBool isLoadingUsers = false.obs;
  final RxString userErrorMessage = ''.obs;

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

    ever(
      Get.find<PostController>().lastBookmarkEvent,
      (event) {
        if (event == null) return;
        _syncBookmark(event.postId, event.isBookmarked, event.bookmarkCount);
      },
    );

    ever(
      Get.find<PostController>().lastDeleteEvent,
      (postId) {
        if (postId == null) return;
        _removePostFromList(postId);
        searchResultController._removePostFromList(postId);
      },
    );
    ever(
      Get.find<PostController>().lastUpdateEvent,
      (event) {
        if (event == null) return;
        _updatePostInList(event.postId, event.title, event.tags);
        searchResultController._updatePostInList(event.postId, event.title, event.tags);
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
    }
    final viewIndex = viewPostList.indexWhere((p) => p.postId == postId);
    if (viewIndex != -1) {
      viewPostList[viewIndex] = viewPostList[viewIndex].copyWith(
        likeCount: likeCount,
        isFavorite: isLiked,
      );
    }
    _updateRankPostLikeInList(postId, isLiked, likeCount: likeCount);
  }

  void _syncBookmark(int postId, bool isBookmarked, int bookmarkCount) {
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        bookmarkCount: bookmarkCount,
        isBookmark: isBookmarked,
      );
      viewPostList.assignAll(_cachePostList);
    }
  }

  Future<void> _loadRecentPopularPostList() async {
    isLoadingRanks.value = true;
    rankErrorMessage.value = '';
    try {
      final result = await loadRecentPopularPostListUseCase();
      if (result.isNotEmpty) result.sort((a, b) => a.rank - b.rank);
      final applied = await Future.wait(
        result.map((post) async => post.copyWith(
          isFavorite: await likedPostUseCase(post.postId),
        )),
      );
      recentPopularPostList.assignAll(applied);
    } catch (e) {
      debugPrint('[HomeController] 인기 게시물 조회 실패 - error: $e');
      rankErrorMessage.value = '인기 게시물을 불러오지 못했어요.';
    } finally {
      isLoadingRanks.value = false;
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
      errorMessage.value = '';
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
            isBookmark: await bookmarkedPostUseCase(post.postId),
          );
        }),
      );

      _cachePostList.addAll(applied);
      viewPostList.assignAll(_cachePostList);
      isLast = result.last ?? true;
      _currentPage++;
    } catch (e) {
      debugPrint('[HomeController] 추천 게시물 조회 실패 - error: $e');
      errorMessage.value = '게시물을 불러오지 못했어요.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() => _loadRecommendPostList();

  Future<void> retryLoadRanks() => _loadRecentPopularPostList();

  void _removePostFromList(int postId) {
    _cachePostList.removeWhere((p) => p.postId == postId);
    viewPostList.assignAll(_cachePostList);
  }

  void _updatePostInList(int postId, String title, List<String> tags) {
    final index = _cachePostList.indexWhere((p) => p.postId == postId);
    if (index == -1) return;
    _cachePostList[index] = _cachePostList[index].copyWith(title: title, tags: tags);
    viewPostList.assignAll(_cachePostList);
  }

  @override
  Future<void> refresh() async {
    await _loadRecommendPostList(refresh: true);
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    _updatePostLikeInList(postId, isLiked);
    _updateRankPostLikeInList(postId, isLiked);
    // 로컬 캐시를 먼저 저장해야 PostDetail 진입 시 _initIsFavorite()가 최신 상태를 읽는다
    await savePostLikeLocalUseCase(postId, isLiked);

    try {
      if (isLiked) {
        await likePostUseCase(postId);
      } else {
        await unlikePostUseCase(postId);
      }
    } catch (e) {
      debugPrint('[HomeController] 좋아요 토글 실패 - error: $e');
      _updatePostLikeInList(postId, !isLiked);
      _updateRankPostLikeInList(postId, !isLiked);
      await savePostLikeLocalUseCase(postId, !isLiked);
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

  Future<void> toggleBookmark(int postId, bool isBookmarked) async {
    _updatePostBookmarkInList(postId, isBookmarked);

    try {
      if (isBookmarked) {
        await bookmarkPostUseCase(postId);
      } else {
        await unbookmarkPostUseCase(postId);
      }
      await savePostBookmarkLocalUseCase(postId, isBookmarked);
    } catch (e) {
      debugPrint('[HomeController] 북마크 토글 실패 - error: $e');
      _updatePostBookmarkInList(postId, !isBookmarked);
    }
  }

  void _updatePostBookmarkInList(int postId, bool isBookmark) {
    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        bookmarkCount:
            _cachePostList[cacheIndex].bookmarkCount + (isBookmark ? 1 : -1),
        isBookmark: isBookmark,
      );
    }
    viewPostList.assignAll(_cachePostList);
  }

  void _updateRankPostLikeInList(int postId, bool isFavorite, {int? likeCount}) {
    final index = recentPopularPostList.indexWhere((p) => p.postId == postId);
    if (index == -1) return;
    final current = recentPopularPostList[index];
    recentPopularPostList[index] = current.copyWith(
      likeCount: likeCount ?? (current.likeCount + (isFavorite ? 1 : -1)),
      isFavorite: isFavorite,
    );
  }

  Future<void> loadRecommendUsers() async {
    _userCurrentPage = 0;
    _isUserLast = false;
    _cacheProfileList.clear();
    userErrorMessage.value = '';
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
      userErrorMessage.value = '추천 커피챗 파트너를 불러오지 못했어요.';
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
      searchResultController.errorMessage.value = '검색에 실패했어요.';
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
  final RxString errorMessage = ''.obs;

  String get currentQuery => _currentQuery;
  int get nextPostPage => _postCurrentPage;
  bool get canLoadMore => !isLastPage.value && !isLoading.value;

  void _prepareNewSearch(String query) {
    _currentQuery = query;
    _postCurrentPage = 0;
    isLastPage.value = false;
    errorMessage.value = '';
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

  void _removePostFromList(int postId) {
    _cachePostList.removeWhere((p) => p.postId == postId);
    viewPostList.assignAll(_cachePostList);
  }

  void _updatePostInList(int postId, String title, List<String> tags) {
    final index = _cachePostList.indexWhere((p) => p.postId == postId);
    if (index == -1) return;
    _cachePostList[index] = _cachePostList[index].copyWith(title: title, tags: tags);
    viewPostList.assignAll(_cachePostList);
  }
}