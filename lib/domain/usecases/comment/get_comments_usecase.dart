import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<ListableWrapper<CommentModel>> call(int postId, {int page = 0, int size = 10}) async {
    return await repository.getComments(postId, page: page, size: size);
  }
}