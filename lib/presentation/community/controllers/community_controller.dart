import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmarked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_bookmark_local_use_case.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class CommunityController extends GetxController {
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final LoadRecommendPostListUseCase _getRecommendPostsUseCase;
  final SavePostLikeLocalUseCase _savePostLikeLocalUseCase;
  final LikedPostUseCase _likedPostUseCase;
  final BookmarkPostUseCase _bookmarkUseCase;
  final UnbookmarkPostUseCase _unbookmarkUseCase;
  final SavePostBookmarkLocalUseCase _savePostBookmarkLocalUseCase;
  final BookmarkedPostUseCase _bookmarkedPostUseCase;

  CommunityController({
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
    required LoadRecommendPostListUseCase getRecommendPostsUseCase,
    required SavePostLikeLocalUseCase savePostLikeLocalUseCase,
    required LikedPostUseCase likedPostUseCase,
    required BookmarkPostUseCase bookmarkUseCase,
    required UnbookmarkPostUseCase unbookmarkUseCase,
    required SavePostBookmarkLocalUseCase savePostBookmarkLocalUseCase,
    required BookmarkedPostUseCase bookmarkedPostUseCase,
  })  : _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase,
        _getRecommendPostsUseCase = getRecommendPostsUseCase,
        _savePostLikeLocalUseCase = savePostLikeLocalUseCase,
        _likedPostUseCase = likedPostUseCase,
        _bookmarkUseCase = bookmarkUseCase,
        _unbookmarkUseCase = unbookmarkUseCase,
        _savePostBookmarkLocalUseCase = savePostBookmarkLocalUseCase,
        _bookmarkedPostUseCase = bookmarkedPostUseCase;

  final RxSet<String> viewTagList = <String>{}.obs;
  final RxSet<String> selectTagList = <String>{}.obs;

  final List<PostEntity> _cachePostList = <PostEntity>[];
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLastPage = false.obs;

  int _currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    viewTagList.addAll(_getTags());
    loadRecommendPostList();

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

  @override
  void onReady() {
    Get.put(CommunityResultController());
    super.onReady();
  }

  Future<void> loadRecommendPostList({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _cachePostList.clear();
      viewPostList.clear();
      isLastPage.value = false;
    }

    if (isLastPage.value) return;

    isLoading.value = true;

    try {
      final result = await _getRecommendPostsUseCase(
        page: _currentPage,
        size: 20,
      );

      final applied = await Future.wait(
        result.content.map((post) async {
          return post.copyWith(
            isFavorite: await _likedPostUseCase(post.postId),
            isBookmark: await _bookmarkedPostUseCase(post.postId),
          );
        }),
      );

      _cachePostList.addAll(applied);
      viewPostList.assignAll(_cachePostList);

      isLastPage.value = result.last ?? true;
      _currentPage++;
    } catch (e) {
      debugPrint('[CommunityController] 게시물 조회 실패 - error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadRecommendPostList(refresh: true);
  }

  Future<void> refreshPosts() => loadRecommendPostList(refresh: true);

  void enterPostCreate() {
    Get.delete<CommunityPostCreateController>(force: true);
    Get.lazyPut(
          () => CommunityPostCreateController(
        createUseCase: Get.find<CreatePostUseCase>(),
        updateUseCase: Get.find<UpdatePostUseCase>(),
      ),
    );
    Get.to(() => CommunityPostCreateScreen());
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    _updatePostLikeInList(postId, isLiked ? 1 : -1, isLiked);

    try {
      if (isLiked) {
        await _likeUseCase(postId);
      } else {
        await _unlikeUseCase(postId);
      }
      await _savePostLikeLocalUseCase(postId, isLiked);
    } catch (e) {
      debugPrint('[CommunityController] 좋아요 토글 실패 - error: $e');
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

  Future<void> toggleBookmark(int postId, bool isBookmarked) async {
    _updatePostBookmarkInList(postId, isBookmarked ? 1 : -1, isBookmarked);

    try {
      if (isBookmarked) {
        await _bookmarkUseCase(postId);
      } else {
        await _unbookmarkUseCase(postId);
      }
      await _savePostBookmarkLocalUseCase(postId, isBookmarked);
    } catch (e) {
      debugPrint('[CommunityController] 북마크 토글 실패 - error: $e');
      _updatePostBookmarkInList(postId, isBookmarked ? -1 : 1, !isBookmarked);
    }
  }

  void _updatePostBookmarkInList(int postId, int delta, bool isBookmark) {
    final index = viewPostList.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      viewPostList[index] = viewPostList[index].copyWith(
        bookmarkCount: viewPostList[index].bookmarkCount + delta,
        isBookmark: isBookmark,
      );
      viewPostList.refresh();
    }

    final cacheIndex = _cachePostList.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePostList[cacheIndex] = _cachePostList[cacheIndex].copyWith(
        bookmarkCount: _cachePostList[cacheIndex].bookmarkCount + delta,
        isBookmark: isBookmark,
      );
    }
  }

  void removePost(int postId) {
    viewPostList.removeWhere((p) => p.postId == postId);
    _cachePostList.removeWhere((p) => p.postId == postId);
  }

  void searchPost(List<String> searchList) {
    final Set<PostEntity> result = {};
    result.addAllIf(
      searchList.isNotEmpty,
      _cachePostList.where(
            (post) =>
        searchList.any((search) => post.title.contains(search)) ||
            searchList.any((search) => post.authorName.contains(search)) ||
            searchList.any(
                  (search) => post.tags.any((tag) => tag.contains(search)),
            ),
      ),
    );
    Get.find<CommunityResultController>().updateResult(result);
  }

  void filterPostTag(String tag, bool isSelect) {
    isSelect ? selectTagList.add(tag) : selectTagList.remove(tag);

    if (selectTagList.isEmpty) {
      viewPostList.assignAll(_cachePostList);
      return;
    }

    final result = _cachePostList
        .where(
          (post) =>
      selectTagList.any((t) => post.title.contains(t)) ||
          selectTagList.any((t) => post.authorName.contains(t)) ||
          selectTagList.any(
                (t) => post.tags.any((skill) => skill.contains(t)),
          ),
    )
        .toList();

    viewPostList.assignAll(result);
  }
}

class CommunityResultController extends GetxController {
  final RxList<PostEntity> viewPosts = <PostEntity>[].obs;

  void updateResult(Iterable<PostEntity> results) {
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