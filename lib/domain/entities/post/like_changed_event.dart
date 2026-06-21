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
