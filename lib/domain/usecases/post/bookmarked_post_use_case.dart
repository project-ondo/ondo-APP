import 'package:ondo/domain/repositories/post/post_repository.dart';

class BookmarkedPostUseCase {
  final PostRepository _repository;

  BookmarkedPostUseCase(this._repository);

  Future<bool> call(int postId) {
    return _repository.bookmarkedPost(postId);
  }
}
