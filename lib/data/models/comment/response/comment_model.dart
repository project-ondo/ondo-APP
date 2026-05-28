import 'package:ondo/domain/entities/comment/comment_entity.dart';

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
    id: int.tryParse(json['commentId'].toString()) ?? 0,
    postId: int.tryParse(json['postId'].toString()) ?? 0,
    content: json['content'] ?? '',
    author: json['authorName'],
  );

  Map<String, dynamic> toJson() => {
    'commentId': id,
    'postId': postId,
    'content': content,
    'authorName': author,
  };

  CommentEntity toEntity({required int? currentUserId}) => CommentEntity(
    id: id,
    postId: postId,
    content: content,
    author: author,
    isMy: currentUserId != null && currentUserId == id,
  );

}