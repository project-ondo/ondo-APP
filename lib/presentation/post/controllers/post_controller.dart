import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/domain/entities/post/like_changed_event.dart';
import 'package:ondo/domain/entities/post/post_updated_event.dart';

class PostController extends GetxController {
  /// 상세 화면에서 변경된 좋아요 상태를 게시물 목록 화면들에 전파
  final Rx<LikeChangedEvent?> lastLikeEvent = Rx<LikeChangedEvent?>(null);

  /// 게시물 삭제 이벤트 — postId
  final Rx<int?> lastDeleteEvent = Rx<int?>(null);

  /// 게시물 수정 이벤트 — 제목/태그가 바뀐 경우
  final Rx<PostUpdatedEvent?> lastUpdateEvent = Rx<PostUpdatedEvent?>(null);

  void updateLikeState(int postId, bool isLiked, int likeCount) {
    lastLikeEvent.value = LikeChangedEvent(
      postId: postId,
      isLiked: isLiked,
      likeCount: likeCount,
    );
  }

  void notifyPostDeleted(int postId) {
    lastDeleteEvent.value = postId;
  }

  void notifyPostUpdated(int postId, String title, List<String> tags) {
    lastUpdateEvent.value = PostUpdatedEvent(
      postId: postId,
      title: title,
      tags: tags,
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
