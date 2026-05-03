import '../../../data/models/post/response/post_detail_model.dart';
import '../../../domain/repositories/post/post_repository.dart';

class GetPostDetailUseCase {
  final PostRepository _repository;
  GetPostDetailUseCase(this._repository);

  Future<PostDetailModel> call(int postId) => _repository.getPostDetail(postId);
}