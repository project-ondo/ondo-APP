import '../../../domain/repositories/post/post_repository.dart';

class LikePostUseCase {
  final PostRepository _repository;
  LikePostUseCase(this._repository);

  Future<void> call(int postId) => _repository.likePost(postId);
}