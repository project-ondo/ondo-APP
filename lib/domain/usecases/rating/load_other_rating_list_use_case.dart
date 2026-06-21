import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class LoadOtherRatingListUseCase {
  final RatingRepository repository;

  LoadOtherRatingListUseCase({required this.repository});

  Future<PageableWrapper<RatingEntity>> call({
    required String userPublicId,
    required int cursor,
    required int size,
  }) async {
    return await repository.loadOtherRatingList(userPublicId, cursor, size);
  }
}
