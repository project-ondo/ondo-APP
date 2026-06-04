import 'package:ondo/domain/entities/post/post_rank_entity.dart';
import 'package:ondo/domain/repositories/post/post_repository.dart';

class LoadRecentPopularPostListUseCase {
  final PostRepository _repository;

  LoadRecentPopularPostListUseCase(this._repository);

  Future<List<PostRankEntity>> call() async {
    return _repository.loadRecentPopularPostList();
  }
}
