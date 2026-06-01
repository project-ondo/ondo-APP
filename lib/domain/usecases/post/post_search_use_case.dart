import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/repositories/post/post_repository.dart';

class PostSearchUseCase {
  final PostRepository _repository;

  PostSearchUseCase(this._repository);

  Future<ListableWrapper<PostEntity>> call({
    required String keyword,
    List<String>? tags,
    String? sort,
    bool? latest,
    int? page,
    int? size,
  }) async {
    return _repository.search(keyword, tags, sort, latest, page, size);
  }
}
