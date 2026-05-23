import 'package:ondo/domain/repositories/post/post_repository.dart';

class SavePostLikeLocalUseCase {
  final PostRepository _repository;

  SavePostLikeLocalUseCase(this._repository);

  Future<void> call(int postId, bool isLiked) {
    return _repository.saveLikeState(postId, isLiked);
  }
}
