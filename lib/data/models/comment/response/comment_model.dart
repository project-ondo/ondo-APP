class CommentModel {
  final int id;
  final int postId;
  final String content;
  final String? author;
  final bool isMy;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    this.author,
    this.isMy = true,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['commentId'],
    postId: json['postId'] ?? 0,
    content: json['content'],
    author: json['authorName'],
    isMy: json['isMY'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'commentId': id,
    'postId': postId,
    'content': content,
    'authorName': author,
    'isMy': isMy,
  };
}