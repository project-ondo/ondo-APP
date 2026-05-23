import 'package:ondo/data/models/comment/response/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getComments(int postId);

  Future<void> createComment({
    required int postId,
    required String content,
  });

  Future<void> deleteComment(int commentId);
}