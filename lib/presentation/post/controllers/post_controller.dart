import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/domain/entities/post/bookmark_changed_event.dart';
import 'package:ondo/domain/entities/post/like_changed_event.dart';

class PostController extends GetxController {
  /// 상세 화면에서 변경된 좋아요 상태를 게시물 목록 화면들에 전파하기 위한 이벤트.
  /// 게시물 목록 화면 컨트롤러(Home/Community 등)는 PostController를 통해 상세
  /// 화면으로 진입하므로, 좋아요 동기화 이벤트도 PostController에서 관리한다.
  final Rx<LikeChangedEvent?> lastLikeEvent = Rx<LikeChangedEvent?>(null);

  /// 좋아요와 동일하게, 상세 화면에서 변경된 북마크 상태를 목록 화면들에 전파한다.
  final Rx<BookmarkChangedEvent?> lastBookmarkEvent =
      Rx<BookmarkChangedEvent?>(null);

  void updateLikeState(int postId, bool isLiked, int likeCount) {
    lastLikeEvent.value = LikeChangedEvent(
      postId: postId,
      isLiked: isLiked,
      likeCount: likeCount,
    );
  }

  void updateBookmarkState(int postId, bool isBookmarked, int bookmarkCount) {
    lastBookmarkEvent.value = BookmarkChangedEvent(
      postId: postId,
      isBookmarked: isBookmarked,
      bookmarkCount: bookmarkCount,
    );
  }

  Future<Map<String, dynamic>?> enterPostDetail(
      BuildContext context,
      bool isMy,
      int postId,
      ) async {
    final result = await context.push<Map<String, dynamic>>(
      '/post/$postId',
    );
    return result;
  }
}
