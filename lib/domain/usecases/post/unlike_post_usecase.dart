import '../../../domain/repositories/post/post_repository.dart';

class UnlikePostUseCase {
  final PostRepository _repository;
  UnlikePostUseCase(this._repository);

  Future<void> call(int postId) => _repository.unlikePost(postId);
}