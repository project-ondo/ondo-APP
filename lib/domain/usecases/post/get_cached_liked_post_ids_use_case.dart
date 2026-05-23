import 'package:ondo/domain/repositories/post/post_repository.dart';

class GetCachedLikedPostIdsUseCase {
  final PostRepository _repository;

  GetCachedLikedPostIdsUseCase(this._repository);

  Future<Set<int>> call() {
    return _repository.getCachedLikedPostIds();
  }
}
