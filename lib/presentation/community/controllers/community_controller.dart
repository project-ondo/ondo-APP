import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/models/post/response/post_list_model.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import 'package:ondo/domain/usecases/post/get_recommend_posts_usecase.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';

class CommunityController extends GetxController {
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final GetRecommendPostsUseCase _getRecommendPostsUseCase;
  final SavePostLikeLocalUseCase _savePostLikeLocalUseCase;
  final GetCachedLikedPostIdsUseCase _getCachedLikedPostIdsUseCase;

  CommunityController({
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
    required GetRecommendPostsUseCase getRecommendPostsUseCase,
    required SavePostLikeLocalUseCase savePostLikeLocalUseCase,
    required GetCachedLikedPostIdsUseCase getCachedLikedPostIdsUseCase,
  })  : _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase,
        _getRecommendPostsUseCase = getRecommendPostsUseCase,
        _savePostLikeLocalUseCase = savePostLikeLocalUseCase,
        _getCachedLikedPostIdsUseCase = getCachedLikedPostIdsUseCase;

  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<PostContentModel> _cachePosts = <PostContentModel>[];
  final RxList<PostContentModel> viewPosts = <PostContentModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLastPage = false.obs;

  int _currentPage = 0;
  Set<int> _cachedLikedIds = {};

  @override
  void onInit() {
    super.onInit();
    tags.addAll(_getTags());
    _loadCacheAndFetch();
  }

  Future<void> _loadCacheAndFetch() async {
    _cachedLikedIds = await _getCachedLikedPostIdsUseCase();
    await fetchRecommendPosts();
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

      // 로컬 캐시 기반으로 isFavorite 덮어쓰기 (앱 재시작 후에도 유지)
      final applied = result.content.map((post) {
        if (_cachedLikedIds.contains(post.postId)) {
          return post.copyWith(isFavorite: true);
        }
        // API가 이미 좋아요 상태를 반환한 경우 캐시에도 반영
        if (post.isFavorite) {
          _cachedLikedIds.add(post.postId);
        }
        return post;
      }).toList();

      _cachePosts.addAll(applied);

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

      // 로컬 캐시 갱신 및 영속화
      if (isLiked) {
        _cachedLikedIds.add(postId);
      } else {
        _cachedLikedIds.remove(postId);
      }
      await _savePostLikeLocalUseCase(postId, isLiked);

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
    // 로컬 캐시 동기화 (PostViewController → CommunityController 방향)
    if (isFavorite) {
      _cachedLikedIds.add(postId);
    } else {
      _cachedLikedIds.remove(postId);
    }
    _savePostLikeLocalUseCase(postId, isFavorite);

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