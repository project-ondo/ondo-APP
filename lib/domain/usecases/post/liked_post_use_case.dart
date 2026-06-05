import 'package:ondo/domain/repositories/post/post_repository.dart';

class LikedPostUseCase {
  final PostRepository _repository;

  LikedPostUseCase(this._repository);

  Future<bool> call(int postId) {
    return _repository.likedPost(postId);
  }
}