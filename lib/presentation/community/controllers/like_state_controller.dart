import 'package:get/get.dart';

class LikeChangedEvent {
  final int postId;
  final bool isLiked;
  final int likeCount;

  LikeChangedEvent({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
  });
}

class LikeStateController extends GetxController {
  final Rx<LikeChangedEvent?> lastEvent = Rx<LikeChangedEvent?>(null);

  void updateLikeState(int postId, bool isLiked, int likeCount) {
    lastEvent.value = LikeChangedEvent(
      postId: postId,
      isLiked: isLiked,
      likeCount: likeCount,
    );
  }
}