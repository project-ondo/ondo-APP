import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/domain/entities/comment/comment_entity.dart';
import 'package:ondo/domain/entities/post/post_detail_entity.dart';
import 'package:ondo/domain/usecases/comment/create_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/get_comments_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/delete_post_usecase.dart';
import '../../../domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/save_post_like_local_use_case.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';
import '../../community/controllers/community_post_create_screen_controller.dart';
import '../../community/screens/community_post_create_screen.dart';
import '../widgets/post_report_dialog.dart';

class _PostLikeState {
  const _PostLikeState({
    required this.likeCount,
    required this.isFavorite,
  });

  final int likeCount;
  final bool isFavorite;
}

class PostViewController extends GetxController {
  final int postId;
  final bool initialIsFavorite;
  final GetPostDetailUseCase _useCase;
  final UpdatePostUseCase _updateUseCase;
  final DeletePostUseCase _deleteUseCase;
  final LikePostUseCase _likeUseCase;
  final UnlikePostUseCase _unlikeUseCase;
  final SavePostLikeLocalUseCase _savePostLikeLocalUseCase;
  final GetCachedLikedPostIdsUseCase _getCachedLikedPostIdsUseCase;
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
    required SavePostLikeLocalUseCase savePostLikeLocalUseCase,
    required GetCachedLikedPostIdsUseCase getCachedLikedPostIdsUseCase,
    required BookmarkPostUseCase bookmarkUseCase,
    required UnbookmarkPostUseCase unbookmarkUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  }) : _useCase = useCase,
       _updateUseCase = updateUseCase,
       _deleteUseCase = deleteUseCase,
       _likeUseCase = likeUseCase,
       _unlikeUseCase = unlikeUseCase,
       _savePostLikeLocalUseCase = savePostLikeLocalUseCase,
       _getCachedLikedPostIdsUseCase = getCachedLikedPostIdsUseCase,
       _bookmarkUseCase = bookmarkUseCase,
       _unbookmarkUseCase = unbookmarkUseCase,
       _getCommentsUseCase = getCommentsUseCase,
       _createCommentUseCase = createCommentUseCase,
       _deleteCommentUseCase = deleteCommentUseCase;

  final Rx<PostDetailEntity?> post = Rx<PostDetailEntity?>(null);
  final RxList<PostDetailEntity> postList = <PostDetailEntity>[].obs;

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
    final listState = _resolveLikeStateFromLists();
    if (listState != null) return listState.isFavorite;
    return initialIsFavorite;
  }

  _PostLikeState? _resolveLikeStateFromLists() {
    if (Get.isRegistered<CommunityController>()) {
      final post = Get.find<CommunityController>().viewPosts.firstWhereOrNull(
        (p) => p.postId == postId,
      );
      if (post != null) {
        return _PostLikeState(
          likeCount: post.likeCount,
          isFavorite: post.isFavorite,
        );
      }
    }

    if (Get.isRegistered<HomeController>()) {
      final post = Get.find<HomeController>().viewPostList.firstWhereOrNull(
        (p) => p.postId == postId,
      );
      if (post != null) {
        return _PostLikeState(
          likeCount: post.likeCount,
          isFavorite: post.isFavorite,
        );
      }
    }

    return null;
  }

  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      debugPrint('[PostViewController] API 요청 시작 - postId: $postId');

      final result = await _useCase(postId);
      final resolvedLikeState = await _resolveFetchedLikeState(result);
      final resolvedResult = result.copyWith(
        likeCount: resolvedLikeState.likeCount,
        isFavorite: resolvedLikeState.isFavorite,
      );

      post.value = resolvedResult;
      postList.assignAll([resolvedResult]);

      title.value = resolvedResult.title;
      authorName.value = resolvedResult.authorName;
      bodyText.value = resolvedResult.content;
      postTags.assignAll(resolvedResult.tags);
      heartTotal.value = resolvedResult.likeCount;
      commentCount.value = resolvedResult.commentCount;
      selectHeart.value = resolvedResult.isFavorite;
    } catch (e) {
      debugPrint('[PostViewController] API 요청 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<_PostLikeState> _resolveFetchedLikeState(
    PostDetailEntity result,
  ) async {
    final listState = _resolveLikeStateFromLists();
    if (listState != null) return listState;

    final cachedLikedIds = await _getCachedLikedPostIdsUseCase();
    return _PostLikeState(
      likeCount: result.likeCount,
      isFavorite: cachedLikedIds.contains(postId) || result.isFavorite,
    );
  }

  Future<void> fetchComments() async {
    isCommentsLoading.value = true;

    try {
      debugPrint('[PostViewController] 댓글 조회 요청 - postId: $postId');

      final result = await _getCommentsUseCase(postId);
      comments.assignAll(
        result.map((e) => e.toEntity(currentUserId: null)),
      );

      debugPrint('[PostViewController] 댓글 조회 성공 - count: ${result.length}');
    } catch (e) {
      debugPrint('[PostViewController] 댓글 조회 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> toggleLike(bool isLiked) async {
    final previousIsLiked = selectHeart.value;
    final previousHeartTotal = heartTotal.value;

    selectHeart.value = isLiked;
    heartTotal.value = _nextLikeCount(heartTotal.value, isLiked);
    _syncDetailLikeState();

    try {
      if (isLiked) {
        await _likeUseCase(postId);
      } else {
        await _unlikeUseCase(postId);
      }

      await _savePostLikeLocalUseCase(postId, isLiked);

      if (Get.isRegistered<CommunityController>()) {
        await Get.find<CommunityController>().updatePostLike(
          postId,
          heartTotal.value,
          isLiked,
        );
      }

      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().updatePostLike(
          postId,
          heartTotal.value,
          isLiked,
        );
      }
    } catch (e) {
      debugPrint('[PostViewController] 좋아요 토글 실패 - error: $e');
      selectHeart.value = previousIsLiked;
      heartTotal.value = previousHeartTotal;
      _syncDetailLikeState();
    }
  }

  int _nextLikeCount(int current, bool isLiked) {
    final next = current + (isLiked ? 1 : -1);
    return next < 0 ? 0 : next;
  }

  void _syncDetailLikeState() {
    final current = post.value;
    if (current == null) return;

    final updated = current.copyWith(
      likeCount: heartTotal.value,
      isFavorite: selectHeart.value,
    );

    post.value = updated;
    postList.assignAll([updated]);
  }

  Future<void> toggleBookmark(bool isBookmarked) async {
    selectBookMark.value = isBookmarked;
    bookMarkTotal.value = isBookmarked
        ? bookMarkTotal.value + 1
        : bookMarkTotal.value - 1;

    try {
      if (isBookmarked) {
        await _bookmarkUseCase(postId);
      } else {
        await _unbookmarkUseCase(postId);
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
      debugPrint('[PostViewController] 게시물 수정 요청 - postId: $postId');

      await _updateUseCase(
        postId,
        PostUpdateRequestModel(title: title, content: content, tags: tags),
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
          errorMessage.value = '';

          try {
            debugPrint('[PostViewController] 게시물 삭제 요청 - postId: $postId');

            await _deleteUseCase(postId);

            Get.find<CommunityController>().removePost(postId);
            Get.back(closeOverlays: true);
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
}
