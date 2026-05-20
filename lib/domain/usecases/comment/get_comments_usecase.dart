import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<CommentModel>> call(int postId) async {
    return await repository.getComments(postId);
  }
}