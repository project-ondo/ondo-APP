import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class LoadOtherRatingListUseCase {
  final RatingRepository repository;

  LoadOtherRatingListUseCase({required this.repository});

  Future<List<RatingEntity>> call({
    required String userPublicId,
    required int cursor,
    required int size,
  }) async {
    final res = await repository.loadOtherRatingList(userPublicId, cursor, size);
    return res;
  }
}
