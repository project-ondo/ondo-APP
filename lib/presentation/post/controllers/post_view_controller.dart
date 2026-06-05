import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/domain/entities/comment/comment_entity.dart';
import 'package:ondo/domain/entities/post/post_detail_entity.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/usecases/comment/create_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/get_comments_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/like_state_controller.dart';

import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/delete_post_usecase.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';
import '../../community/controllers/community_post_create_screen_controller.dart';
import '../../community/screens/community_post_create_screen.dart';
import '../widgets/post_report_dialog.dart';

class PostViewController extends GetxController {
  final int postId;
  final bool initialIsFavorite;

  final GetPostDetailUseCase _getPostDetailUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final LikePostUseCase _likePostUseCase;
  final UnlikePostUseCase _unlikePostUseCase;
  final BookmarkPostUseCase _bookmarkPostUseCase;
  final UnbookmarkPostUseCase _unbookmarkPostUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final LikedPostUseCase _likedPostUseCase;
  final SavePostLikeLocalUseCase _savePostLikeLocalUseCase;

  PostViewController({
    required this.postId,
    this.initialIsFavorite = false,
    required GetPostDetailUseCase getPostDetailUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
    required LikePostUseCase likePostUseCase,
    required UnlikePostUseCase unlikePostUseCase,
    required BookmarkPostUseCase bookmarkPostUseCase,
    required UnbookmarkPostUseCase unbookmarkPostUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
    required LikedPostUseCase likedPostUseCase,
    required SavePostLikeLocalUseCase savePostLikeLocalUseCase,
  })  : _getPostDetailUseCase = getPostDetailUseCase,
        _updatePostUseCase = updatePostUseCase,
        _deletePostUseCase = deletePostUseCase,
        _likePostUseCase = likePostUseCase,
        _unlikePostUseCase = unlikePostUseCase,
        _bookmarkPostUseCase = bookmarkPostUseCase,
        _unbookmarkPostUseCase = unbookmarkPostUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        _createCommentUseCase = createCommentUseCase,
        _deleteCommentUseCase = deleteCommentUseCase,
        _likedPostUseCase = likedPostUseCase,
        _savePostLikeLocalUseCase = savePostLikeLocalUseCase;

  final Rx<PostDetailEntity?> post = Rx<PostDetailEntity?>(null);
  final RxList<PostEntity> relatedPostList = <PostEntity>[].obs;

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

  bool initialHeartState = false;

  @override
  void onInit() {
    super.onInit();
    commentController = TextEditingController();
    _initIsFavorite();
    fetchPostDetail(postId);
    fetchComments();
  }

  Future<void> _initIsFavorite() async {
    final liked = await _likedPostUseCase(postId);
    selectHeart.value = liked;
    initialHeartState = liked;
  }


  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _getPostDetailUseCase(postId);

      post.value = result;
      title.value = result.title;
      authorName.value = result.authorName;
      bodyText.value = result.content;
      postTags.assignAll(result.tags);

      heartTotal.value = result.likeCount;
      bookMarkTotal.value = result.bookmarkCount;
      commentCount.value = result.commentCount;
    } catch (e) {
      debugPrint('[PostViewController] API 요청 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchComments() async {
    isCommentsLoading.value = true;

    try {
      final result = await _getCommentsUseCase(postId);
      comments.assignAll(
        result.map((e) => e.toEntity(currentUserId: null)),
      );
    } catch (e) {
      debugPrint('[PostViewController] 댓글 조회 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isCommentsLoading.value = false;
    }
  }


  Future<void> toggleLike(bool isLiked) async {
    selectHeart.value = isLiked;
    heartTotal.value = isLiked ? heartTotal.value + 1 : heartTotal.value - 1;

    try {
      if (isLiked) {
        await _likePostUseCase(postId);
      } else {
        await _unlikePostUseCase(postId);
      }
      await _savePostLikeLocalUseCase(postId, isLiked);


      Get.find<LikeStateController>().updateLikeState(
        postId,
        isLiked,
        heartTotal.value,
      );
    } catch (e) {
      debugPrint('[PostViewController] 좋아요 토글 실패 - error: $e');
      selectHeart.value = !isLiked;
      heartTotal.value = isLiked ? heartTotal.value - 1 : heartTotal.value + 1;
    }
  }

  Future<void> toggleBookmark(bool isBookmarked) async {
    selectBookMark.value = isBookmarked;
    bookMarkTotal.value = isBookmarked
        ? bookMarkTotal.value + 1
        : bookMarkTotal.value - 1;

    try {
      if (isBookmarked) {
        await _bookmarkPostUseCase(postId);
      } else {
        await _unbookmarkPostUseCase(postId);
      }
    } catch (e) {
      debugPrint('[PostViewController] 북마크 토글 실패 - error: $e');
      selectBookMark.value = !isBookmarked;
      bookMarkTotal.value = isBookmarked
          ? bookMarkTotal.value - 1
          : bookMarkTotal.value + 1;
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
      await _updatePostUseCase(
        postId,
        PostUpdateRequestModel(
          title: title,
          content: content,
          tags: tags,
        ),
      );
      await fetchPostDetail(postId);
    } catch (e) {
      debugPrint('[PostViewController] 게시물 수정 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  void deletePost() {
    Get.dialog(
      CustomAlertDialog(
        title: "알림",
        comment: "정말 게시물 삭제하시겠어요?",
        actionLeft: () => Get.back(),
        actionRight: () async {
          isLoading.value = true;

          try {
            await _deletePostUseCase(postId);

            Get.back();
            Get.back(result: {'postId': postId, 'deleted': true});
          } catch (e) {
            debugPrint('[PostViewController] 게시물 삭제 실패 - error: $e');
            errorMessage.value = e.toString();
          } finally {
            isLoading.value = false;
          }
        },
        rightActionText: "삭제",
      ),
    );
  }


  Future<void> createComment(String content) async {
    if (content.trim().isEmpty) return;

    try {
      await _createCommentUseCase(postId: postId, content: content);
      commentController.clear();
      await fetchComments();
      commentCount.value = comments.length;
    } catch (e) {
      debugPrint('[PostViewController] 댓글 작성 실패 - error: $e');
    }
  }

  Future<void> deleteComment(CommentEntity comment) async {
    try {
      await _deleteCommentUseCase(comment.id);
      await fetchComments();
      commentCount.value = comments.length;
    } catch (e) {
      debugPrint('[PostViewController] 댓글 삭제 실패 - error: $e');
    }
  }


  void reportPost() {
    Get.dialog(PostReportDialog());
  }


  void editPost() {
    Get.delete<CommunityPostCreateController>(force: true);
    Get.lazyPut(
          () => CommunityPostCreateController(
        createUseCase: Get.find<CreatePostUseCase>(),
        updateUseCase: Get.find<UpdatePostUseCase>(),
        isEditMode: true,
        editPostId: postId,
        initialTitle: title.value,
        initialContent: bodyText.value,
        initialTags: postTags.toList(),
      ),
    );
    Get.to(() => CommunityPostCreateScreen());
  }


  void goBack() {
    Get.back(result: {
      'postId': postId,
      'isLiked': selectHeart.value,
      'likeCount': heartTotal.value,
      'changed': selectHeart.value != initialHeartState,
      'deleted': false,
    });
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}