import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';

import '../../../domain/repositories/post/post_repository.dart';

class LoadRecommendPostListUseCase {
  final PostRepository _repository;

  LoadRecommendPostListUseCase(this._repository);

  Future<ListableWrapper<PostEntity>> call({
    required int page,
    required int size,
  }) => _repository.loadRecommendPostList(page, size);
}
