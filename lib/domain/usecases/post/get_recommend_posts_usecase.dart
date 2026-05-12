import '../../../data/models/post/response/post_list_model.dart';
import '../../../domain/repositories/post/post_repository.dart';

class GetRecommendPostsUseCase {
  final PostRepository _repository;
  GetRecommendPostsUseCase(this._repository);

  Future<PostListModel> call({int page = 0}) =>
      _repository.getRecommendPosts(page: page);
}