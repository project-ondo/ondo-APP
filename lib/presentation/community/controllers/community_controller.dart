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
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/controllers/like_state_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';

class CommunityController extends GetxController {
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final LoadRecommendPostListUseCase _getRecommendPostsUseCase;
  final SavePostLikeLocalUseCase _savePostLikeLocalUseCase;
  final LikedPostUseCase _likedPostUseCase;

  CommunityController({
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
    required LoadRecommendPostListUseCase getRecommendPostsUseCase,
    required SavePostLikeLocalUseCase savePostLikeLocalUseCase,
    required LikedPostUseCase likedPostUseCase,
  })  : _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase,
        _getRecommendPostsUseCase = getRecommendPostsUseCase,
        _savePostLikeLocalUseCase = savePostLikeLocalUseCase,
        _likedPostUseCase = likedPostUseCase;

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