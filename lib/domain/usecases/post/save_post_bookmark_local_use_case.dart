import 'package:ondo/domain/repositories/post/post_repository.dart';

class SavePostBookmarkLocalUseCase {
  final PostRepository _repository;

  SavePostBookmarkLocalUseCase(this._repository);

  Future<void> call(int postId, bool isBookmarked) {
    return _repository.saveBookmarkState(postId, isBookmarked);
  }
}
