import 'package:ondo/domain/entities/post/post_detail_entity.dart';
import 'package:ondo/domain/repositories/post/post_repository.dart';

class GetPostDetailUseCase {
  final PostRepository _repository;

  GetPostDetailUseCase(this._repository);

  Future<PostDetailEntity> call(int postId) =>
      _repository.loadPostDetail(postId);
}
