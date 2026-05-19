import 'package:dartz/dartz.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';

abstract class CommentRepository {
  Future<Either<String, List<CommentModel>>> getComments(int postId);
  Future<Either<String, void>> createComment({
    required int postId,
    required String content,
  });
  Future<Either<String, void>> deleteComment(int commentId);
}