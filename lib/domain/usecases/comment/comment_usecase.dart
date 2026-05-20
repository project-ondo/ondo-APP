import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<CommentModel>> call(int postId) async {
    return await repository.getComments(postId);
  }
}

class CreateCommentUseCase {
  final CommentRepository repository;

  CreateCommentUseCase(this.repository);

  Future<void> call({
    required int postId,
    required String content,
  }) async {
    try {
      await repository.createComment(
        postId: postId,
        content: content,
      );
    } catch (e) {
      throw Exception('댓글 작성 실패: $e');
    }
  }
}

class DeleteCommentUseCase {
  final CommentRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> call(int commentId) async {
    try {
      await repository.deleteComment(commentId);
    } catch (e) {
      throw Exception('댓글 삭제 실패: $e');
    }
  }
}
