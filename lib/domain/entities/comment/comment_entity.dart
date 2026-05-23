class CommentEntity {
  final int id;
  final int postId;
  final String content;
  final String? author;
  final bool isMy;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.content,
    this.author,
    required this.isMy,
  });
}