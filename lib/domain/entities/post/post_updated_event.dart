class PostUpdatedEvent {
  final int postId;
  final String title;
  final List<String> tags;

  PostUpdatedEvent({
    required this.postId,
    required this.title,
    required this.tags,
  });
}
