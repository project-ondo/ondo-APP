class CommentModel {
  final int id;
  final int postId;
  final String content;
  final String? author;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    this.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['commentId'],
    postId: json['postId'] ?? 0,
    content: json['content'],
    author: json['authorName'],
  );

  Map<String, dynamic> toJson() => {
    'commentId': id,
    'postId': postId,
    'content': content,
    'authorName': author,
  };
}