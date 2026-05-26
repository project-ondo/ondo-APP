import 'package:ondo/domain/repositories/post/post_repository.dart';

class UnbookmarkPostUseCase {
  final PostRepository repository;
  UnbookmarkPostUseCase(this.repository);

  Future<void> call(int postId) async {
    return await repository.unbookmarkPost(postId);
  }
}