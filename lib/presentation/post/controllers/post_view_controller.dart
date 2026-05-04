import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/models/post/post_info.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../data/models/post/response/post_detail_model.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';

class PostViewController extends GetxController {
  final int postId;
  final GetPostDetailUseCase _useCase;
  final UpdatePostUseCase _updateUseCase;
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;

  PostViewController({
    required this.postId,
    required GetPostDetailUseCase useCase,
    required UpdatePostUseCase updateUseCase,
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
  })  : _useCase = useCase,
        _updateUseCase = updateUseCase,
        _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase;

  final Rx<PostDetailModel?> post = Rx<PostDetailModel?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxString title = ''.obs;
  final RxString authorName = ''.obs;
  final RxString bodyText = ''.obs;
  final RxList<String> postTags = <String>[].obs;
  final Rx<Duration> postAt = Duration.zero.obs;

  final RxBool selectHeart = false.obs;
  final RxBool selectBookMark = false.obs;

  final RxInt heartTotal = 0.obs;
  final RxInt bookMarkTotal = 0.obs;
  final RxInt commentCount = 0.obs;

  final RxList<Comment> comments = <Comment>[].obs;
  final RxList<PostInfo> postList = <PostInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[PostViewController] onInit - postId: $postId');
    fetchPostDetail(postId);
  }

  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      debugPrint('[PostViewController] API 요청 시작 - postId: $postId');
      final result = await _useCase(postId);
      post.value = result;
      debugPrint('[PostViewController] API 응답 성공 - title: ${result.title}');
      title.value = result.title;
      authorName.value = result.authorName;
      bodyText.value = result.content;
      postTags.assignAll(result.tags);
      heartTotal.value = result.likeCount;
      commentCount.value = result.commentCount;
    } catch (e) {
      debugPrint('[PostViewController] API 요청 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleLike(bool isLiked) async {
    try {
      if (isLiked) {
        debugPrint('[PostViewController] 좋아요 요청 - postId: $postId');
        await _likeUseCase(postId);
        heartTotal.value += 1;
        selectHeart.value = true;
        debugPrint('[PostViewController] 좋아요 성공');
      } else {
        debugPrint('[PostViewController] 좋아요 취소 요청 - postId: $postId');
        await _unlikeUseCase(postId);
        heartTotal.value -= 1;
        selectHeart.value = false;
        debugPrint('[PostViewController] 좋아요 취소 성공');
      }

      // 커뮤니티 화면 동기화
      Get.find<CommunityController>().updatePostLike(
        postId,
        heartTotal.value,
        isLiked,
      );
    } catch (e) {
      debugPrint('[PostViewController] 좋아요 토글 실패 - error: $e');
      selectHeart.value = !isLiked;
      heartTotal.value += isLiked ? -1 : 1;
    }
  }

  Future<void> updatePost({
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      debugPrint('[PostViewController] 게시물 수정 요청 - postId: $postId');
      await _updateUseCase(
        postId,
        PostUpdateRequestModel(title: title, content: content, tags: tags),
      );
      debugPrint('[PostViewController] 게시물 수정 성공');
      await fetchPostDetail(postId);
    } catch (e) {
      debugPrint('[PostViewController] 게시물 수정 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void deletePostRequest() {}
}

typedef Comment = ({
String author,
String comment,
int heartTotal,
});