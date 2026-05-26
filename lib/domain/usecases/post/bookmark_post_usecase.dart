import 'package:ondo/domain/repositories/post/post_repository.dart';

class BookmarkPostUseCase {
  final PostRepository repository;
  BookmarkPostUseCase(this.repository);

  Future<void> call(int postId) async {
    return await repository.bookmarkPost(postId);
  }
}