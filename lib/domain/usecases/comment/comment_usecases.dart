import 'package:dartz/dartz.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;
  GetCommentsUseCase(this.repository);

  Future<Either<String, List<CommentModel>>> call(int postId) =>
      repository.getComments(postId);
}

class CreateCommentUseCase {
  final CommentRepository repository;
  CreateCommentUseCase(this.repository);

  Future<Either<String, void>> call({
    required int postId,
    required String content,
  }) =>
      repository.createComment(postId: postId, content: content);
}

class DeleteCommentUseCase {
  final CommentRepository repository;
  DeleteCommentUseCase(this.repository);

  Future<Either<String, void>> call(int commentId) =>
      repository.deleteComment(commentId);
}