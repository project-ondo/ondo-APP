import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../domain/repositories/post/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository _repository;
  UpdatePostUseCase(this._repository);

  Future<void> call(int postId, PostUpdateRequestModel model) =>
      _repository.updatePost(postId, model);
}