import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class CreateCommentUseCase {
  final CommentRepository repository;

  CreateCommentUseCase(this.repository);

  Future<bool> call({
    required int postId,
    required String content,
  }) async {
    try {
      return await repository.createComment(
        postId: postId,
        content: content,
      );
    } catch (e) {
      throw Exception('댓글 작성 실패: $e');
    }
  }
}
