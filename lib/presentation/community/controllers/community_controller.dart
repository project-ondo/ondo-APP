import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/models/post/post_info.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';

class CommunityController extends GetxController {
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;

  CommunityController({
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
  })  : _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase;

  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<PostInfo> _cachePosts = <PostInfo>[];
  final RxList<PostInfo> viewPosts = <PostInfo>[].obs;

  @override
  void onInit() {
    tags.addAll(_getTags());
    _cachePosts.addAll(_getPosts());
    viewPosts.addAll(_cachePosts);
    super.onInit();
  }

  @override
  void onReady() {
    Get.put(CommunityResultController());
    super.onReady();
  }

  void enterPostCreate() {
    Get.lazyPut(() => CommunityPostCreateController());
    Get.to(CommunityPostCreateScreen());
  }

  Future<void> toggleLike(int postId, bool isLiked) async {
    try {
      if (isLiked) {
        await _likeUseCase(postId);
      } else {
        await _unlikeUseCase(postId);
      }
      final index = viewPosts.indexWhere((p) => p.postId == postId);
      if (index != -1) {
        viewPosts[index] = viewPosts[index].copyWith(
          favorites: viewPosts[index].favorites + (isLiked ? 1 : -1),
          isFavorite: isLiked,
        );
      }
      final cacheIndex = _cachePosts.indexWhere((p) => p.postId == postId);
      if (cacheIndex != -1) {
        _cachePosts[cacheIndex] = _cachePosts[cacheIndex].copyWith(
          favorites: _cachePosts[cacheIndex].favorites + (isLiked ? 1 : -1),
          isFavorite: isLiked,
        );
      }
    } catch (e) {
      debugPrint('[CommunityController] 좋아요 토글 실패 - error: $e');
      final index = viewPosts.indexWhere((p) => p.postId == postId);
      if (index != -1) {
        viewPosts[index] = viewPosts[index].copyWith(
          favorites: viewPosts[index].favorites + (isLiked ? -1 : 1),
          isFavorite: !isLiked,
        );
      }
    }
  }

  void updatePostLike(int postId, int likeCount, bool isFavorite) {
    final index = viewPosts.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      viewPosts[index] = viewPosts[index].copyWith(
        favorites: likeCount,
        isFavorite: isFavorite,
      );
    }
    final cacheIndex = _cachePosts.indexWhere((p) => p.postId == postId);
    if (cacheIndex != -1) {
      _cachePosts[cacheIndex] = _cachePosts[cacheIndex].copyWith(
        favorites: likeCount,
        isFavorite: isFavorite,
      );
    }
  }

  void searchPost(List<String> searchList) {
    final Set<PostInfo> result = {};
    result.addAllIf(
      searchList.isNotEmpty,
      _cachePosts.where(
            (post) =>
        searchList.any((search) => post.title.contains(search)) ||
            searchList.any((search) => post.name.contains(search)) ||
            searchList.any(
                  (search) => post.skills.any((skill) => skill.contains(search)),
            ),
      ),
    );
    Get.find<CommunityResultController>().updateResult(result);
  }

  void filterPostTag(String tag, bool isSelect) {
    isSelect ? selectTagList.add(tag) : selectTagList.remove(tag);
    if (selectTagList.isEmpty) {
      viewPosts.assignAll(_cachePosts);
      return;
    }
    final Set<PostInfo> result = {};
    result.addAll(
      _cachePosts.where(
            (post) =>
        selectTagList.any((tag) => post.title.contains(tag)) ||
            selectTagList.any((tag) => post.name.contains(tag)) ||
            selectTagList.any(
                  (tag) => post.skills.any((skill) => skill.contains(tag)),
            ),
      ),
    );
    viewPosts.assignAll(result);
  }
}

class CommunityResultController extends GetxController {
  final RxList<PostInfo> viewPosts = <PostInfo>[].obs;

  void updateResult(Iterable<PostInfo> results) {
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

List<PostInfo> _getPosts() => [
  for (int i = 0; i < 8; i++)
    PostInfo(
      postId: i + 1,
      name: "김유찬",
      title: "요즘 UI UX",
      skills: ["UI/UX", "FrontEnd"],
      bookmarks: 12,
      favorites: 12,
      createAt: DateTime.now(),
      isFavorite: i % 2 == 0,
      isBookmark: i % 3 == 0,
    ),
];