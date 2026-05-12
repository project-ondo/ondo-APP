import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/models/post/response/post_list_model.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/get_recommend_posts_usecase.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';

class CommunityController extends GetxController {
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final GetRecommendPostsUseCase _getRecommendPostsUseCase;

  CommunityController({
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
    required GetRecommendPostsUseCase getRecommendPostsUseCase,
  })  : _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase,
        _getRecommendPostsUseCase = getRecommendPostsUseCase;

  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<PostContentModel> _cachePosts = <PostContentModel>[];
  final RxList<PostContentModel> viewPosts = <PostContentModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLastPage = false.obs;

  int _currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    tags.addAll(_getTags());
    fetchRecommendPosts();
  }

  @override
  void onReady() {
    Get.put(CommunityResultController());
    super.onReady();
  }

  Future<void> fetchRecommendPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _cachePosts.clear();
      viewPosts.clear();
      isLastPage.value = false;
    }

    if (isLastPage.value) return;

    isLoading.value = true;

    try {
      final result = await _getRecommendPostsUseCase(
        page: _currentPage,
      );

      _cachePosts.addAll(result.content);

      viewPosts.assignAll(_cachePosts);

      isLastPage.value = result.last;

      _currentPage++;
    } catch (e) {
      debugPrint(
        '[CommunityController] 게시물 조회 실패 - error: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() =>
      fetchRecommendPosts(refresh: true);

  void enterPostCreate() {
    Get.delete<CommunityPostCreateController>(
      force: true,
    );

    Get.lazyPut(
          () => CommunityPostCreateController(
        createUseCase: Get.find<CreatePostUseCase>(),
        updateUseCase: Get.find<UpdatePostUseCase>(),
      ),
    );

    Get.to(() => CommunityPostCreateScreen());
  }

  Future<void> toggleLike(
      int postId,
      bool isLiked,
      ) async {
    try {
      if (isLiked) {
        await _likeUseCase(postId);
      } else {
        await _unlikeUseCase(postId);
      }

      _updatePostLikeInList(
        postId,
        isLiked ? 1 : -1,
        isLiked,
      );
    } catch (e) {
      debugPrint(
        '[CommunityController] 좋아요 토글 실패 - error: $e',
      );

      _updatePostLikeInList(
        postId,
        isLiked ? -1 : 1,
        !isLiked,
      );
    }
  }

  void _updatePostLikeInList(
      int postId,
      int delta,
      bool isFavorite,
      ) {
    final index =
    viewPosts.indexWhere((p) => p.postId == postId);

    if (index != -1) {
      viewPosts[index] = viewPosts[index].copyWith(
        likeCount: viewPosts[index].likeCount + delta,
        isFavorite: isFavorite,
      );

      viewPosts.refresh();
    }

    final cacheIndex =
    _cachePosts.indexWhere((p) => p.postId == postId);

    if (cacheIndex != -1) {
      _cachePosts[cacheIndex] =
          _cachePosts[cacheIndex].copyWith(
            likeCount:
            _cachePosts[cacheIndex].likeCount + delta,
            isFavorite: isFavorite,
          );
    }
  }

  void updatePostLike(
      int postId,
      int likeCount,
      bool isFavorite,
      ) {
    final index =
    viewPosts.indexWhere((p) => p.postId == postId);

    if (index != -1) {
      viewPosts[index] = viewPosts[index].copyWith(
        likeCount: likeCount,
        isFavorite: isFavorite,
      );

      viewPosts.refresh();
    }

    final cacheIndex =
    _cachePosts.indexWhere((p) => p.postId == postId);

    if (cacheIndex != -1) {
      _cachePosts[cacheIndex] =
          _cachePosts[cacheIndex].copyWith(
            likeCount: likeCount,
            isFavorite: isFavorite,
          );
    }
  }

  void removePost(int postId) {
    viewPosts.removeWhere(
          (p) => p.postId == postId,
    );

    _cachePosts.removeWhere(
          (p) => p.postId == postId,
    );
  }

  void searchPost(List<String> searchList) {
    final Set<PostContentModel> result = {};

    result.addAllIf(
      searchList.isNotEmpty,
      _cachePosts.where(
            (post) =>
        searchList.any(
              (search) =>
              post.title.contains(search),
        ) ||
            searchList.any(
                  (search) =>
                  post.authorName.contains(search),
            ) ||
            searchList.any(
                  (search) => post.tags.any(
                    (tag) => tag.contains(search),
              ),
            ),
      ),
    );

    Get.find<CommunityResultController>()
        .updateResult(result);
  }

  void filterPostTag(
      String tag,
      bool isSelect,
      ) {
    isSelect
        ? selectTagList.add(tag)
        : selectTagList.remove(tag);

    if (selectTagList.isEmpty) {
      viewPosts.assignAll(_cachePosts);
      return;
    }

    final result = _cachePosts.where(
          (post) =>
      selectTagList.any(
            (t) => post.title.contains(t),
      ) ||
          selectTagList.any(
                (t) =>
                post.authorName.contains(t),
          ) ||
          selectTagList.any(
                (t) => post.tags.any(
                  (skill) => skill.contains(t),
            ),
          ),
    ).toList();

    viewPosts.assignAll(result);
  }
}

class CommunityResultController
    extends GetxController {
  final RxList<PostContentModel> viewPosts =
      <PostContentModel>[].obs;

  void updateResult(
      Iterable<PostContentModel> results,
      ) {
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