import 'package:ondo/domain/repositories/comment/comment_repository.dart';

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