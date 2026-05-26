import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/entities/comment/comment_entity.dart';
import 'package:ondo/domain/usecases/comment/create_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/get_comments_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../data/models/post/response/post_detail_model.dart';
import '../../../domain/usecases/post/delete_post_usecase.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';

class PostViewController extends GetxController {
  final int postId;
  final bool initialIsFavorite;

  final GetPostDetailUseCase _useCase;
  final UpdatePostUseCase _updateUseCase;
  final DeletePostUseCase _deleteUseCase;
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final BookmarkPostUseCase _bookmarkUseCase;
  final UnbookmarkPostUseCase _unbookmarkUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  PostViewController({
    required this.postId,
    this.initialIsFavorite = false,
    required GetPostDetailUseCase useCase,
    required UpdatePostUseCase updateUseCase,
    required DeletePostUseCase deleteUseCase,
    required LikePostUseCase likeUseCase,
    required UnlikePostUseCase unlikeUseCase,
    required BookmarkPostUseCase bookmarkUseCase,
    required UnbookmarkPostUseCase unbookmarkUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  })  : _useCase = useCase,
        _updateUseCase = updateUseCase,
        _deleteUseCase = deleteUseCase,
        _likeUseCase = likeUseCase,
        _unlikeUseCase = unlikeUseCase,
        _bookmarkUseCase = bookmarkUseCase,
        _unbookmarkUseCase = unbookmarkUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        _createCommentUseCase = createCommentUseCase,
        _deleteCommentUseCase = deleteCommentUseCase;

  final Rx<PostDetailModel?> post = Rx<PostDetailModel?>(null);
  final RxList<PostDetailModel> postList = <PostDetailModel>[].obs;

  final isLoading = false.obs;
  final isCommentsLoading = false.obs;
  final errorMessage = ''.obs;

  final RxString title = ''.obs;
  final RxString authorName = ''.obs;
  final RxString bodyText = ''.obs;
  final RxList<String> postTags = <String>[].obs;
  final Rx<DateTime> postAt = DateTime.now().obs;

  final RxBool selectHeart = false.obs;
  final RxBool selectBookMark = false.obs;

  final RxInt heartTotal = 0.obs;
  final RxInt bookMarkTotal = 0.obs;
  final RxInt commentCount = 0.obs;

  final RxList<CommentEntity> comments = <CommentEntity>[].obs;

  late final TextEditingController commentController;

  @override
  void onInit() {
    super.onInit();

    commentController = TextEditingController();

    selectHeart.value = _resolveIsFavorite();

    debugPrint(
      '[PostViewController] onInit - postId: $postId, resolvedIsFavorite: ${selectHeart.value}',
    );

    fetchPostDetail(postId);
    fetchComments();
  }

  bool _resolveIsFavorite() {
    if (Get.isRegistered<CommunityController>()) {
      final post = Get.find<CommunityController>()
          .viewPosts
          .firstWhereOrNull((p) => p.postId == postId);

      if (post != null) return post.isFavorite;
    }

    if (Get.isRegistered<HomeController>()) {
      final post = Get.find<HomeController>()
          .viewPostList
          .firstWhereOrNull((p) => p.postId == postId);

      if (post != null) return post.isFavorite;
    }

    return initialIsFavorite;
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      debugPrint(
        '[PostViewController] API 요청 시작 - postId: $postId',
      );

      final result = await _useCase(postId);

      post.value = result;
      postList.assignAll([result]);

      debugPrint(
        '[PostViewController] API 응답 성공 - title: ${result.title}',
      );

      title.value = result.title;
      authorName.value = result.authorName;
      bodyText.value = result.content;
      postTags.assignAll(result.tags);

      heartTotal.value = result.likeCount;
      commentCount.value = result.commentCount;
      selectHeart.value = result.isFavorite;
    } catch (e) {
      debugPrint(
        '[PostViewController] API 요청 실패 - error: $e',
      );

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComments() async {
    isCommentsLoading.value = true;

    try {
      debugPrint(
        '[PostViewController] 댓글 조회 요청 - postId: $postId',
      );

      final result = await _getCommentsUseCase(postId);

      comments.assignAll(
        result.map(
              (e) => e.toEntity(currentUserId: null),
        ),
      );

      debugPrint(
        '[PostViewController] 댓글 조회 성공 - count: ${result.length}',
      );
    } catch (e) {
      debugPrint(
        '[PostViewController] 댓글 조회 실패 - error: $e',
      );

      errorMessage.value = e.toString();
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> toggleLike(bool isLiked) async {
    selectHeart.value = isLiked;

    heartTotal.value =
    isLiked ? heartTotal.value + 1 : heartTotal.value - 1;

    try {
      if (isLiked) {
        await _likeUseCase(postId);
      } else {
        await _unlikeUseCase(postId);
      }

      if (Get.isRegistered<CommunityController>()) {
        await Get.find<CommunityController>().updatePostLike(
          postId,
          heartTotal.value,
          isLiked,
        );
      }

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().updatePostLike(
          postId,
          heartTotal.value,
          isLiked,
        );
      }
    } catch (e) {
      debugPrint(
        '[PostViewController] 좋아요 토글 실패 - error: $e',
      );

      selectHeart.value = !isLiked;

      heartTotal.value =
      isLiked ? heartTotal.value - 1 : heartTotal.value + 1;
    }
  }

  Future<void> toggleBookmark(bool isBookmarked) async {
    selectBookMark.value = isBookmarked;
    bookMarkTotal.value =
    isBookmarked ? bookMarkTotal.value + 1 : bookMarkTotal.value - 1;

    try {
      if (isBookmarked) {
        await _bookmarkUseCase(postId);
      } else {
        await _unbookmarkUseCase(postId);
      }

      debugPrint(
        '[PostViewController] 북마크 토글 성공 - isBookmarked: $isBookmarked',
      );
    } catch (e) {
      debugPrint(
        '[PostViewController] 북마크 토글 실패 - error: $e',
      );

      selectBookMark.value = !isBookmarked;
      bookMarkTotal.value =
      isBookmarked ? bookMarkTotal.value - 1 : bookMarkTotal.value + 1;
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
      debugPrint(
        '[PostViewController] 게시물 수정 요청 - postId: $postId',
      );

      await _updateUseCase(
        postId,
        PostUpdateRequestModel(
          title: title,
          content: content,
          tags: tags,
        ),
      );

      debugPrint('[PostViewController] 게시물 수정 성공');

      await fetchPostDetail(postId);
    } catch (e) {
      debugPrint(
        '[PostViewController] 게시물 수정 실패 - error: $e',
      );

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePost() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      debugPrint(
        '[PostViewController] 게시물 삭제 요청 - postId: $postId',
      );

      await _deleteUseCase(postId);

      debugPrint('[PostViewController] 게시물 삭제 성공');

      Get.find<CommunityController>().removePost(postId);
      Get.back();
    } catch (e) {
      debugPrint(
        '[PostViewController] 게시물 삭제 실패 - error: $e',
      );

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createComment(String content) async {
    if (content.trim().isEmpty) return;

    try {
      debugPrint(
        '[PostViewController] 댓글 작성 요청 - content: $content',
      );

      await _createCommentUseCase(
        postId: postId,
        content: content,
      );

      commentController.clear();

      await fetchComments();

      commentCount.value = comments.length;

      debugPrint('[PostViewController] 댓글 작성 성공');
    } catch (e) {
      debugPrint(
        '[PostViewController] 댓글 작성 실패 - error: $e',
      );
    }
  }

  Future<void> deleteComment(CommentEntity comment) async {
    try {
      debugPrint(
        '[PostViewController] 댓글 삭제 요청 - commentId: ${comment.id}',
      );

      await _deleteCommentUseCase(comment.id);

      await fetchComments();

      commentCount.value = comments.length;

      debugPrint('[PostViewController] 댓글 삭제 성공');
    } catch (e) {
      debugPrint(
        '[PostViewController] 댓글 삭제 실패 - error: $e',
      );
    }
  }
}