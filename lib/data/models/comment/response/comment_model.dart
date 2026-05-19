import 'package:ondo/data/models/comment/response/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.content,
    super.author,
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