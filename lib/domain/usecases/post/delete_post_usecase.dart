import '../../../domain/repositories/post/post_repository.dart';

class DeletePostUseCase {
  final PostRepository _repository;
  DeletePostUseCase(this._repository);

  Future<void> call(int postId) => _repository.deletePost(postId);
}