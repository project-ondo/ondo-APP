import '../../../data/models/post/request/post_create_request_model.dart';
import '../../../domain/repositories/post/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;
  CreatePostUseCase(this._repository);

  Future<int> call(PostCreateRequestModel model) =>
      _repository.createPost(model);
}