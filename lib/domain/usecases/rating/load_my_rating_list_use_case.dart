import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class LoadMyRatingListUseCase {
  final RatingRepository repository;

  LoadMyRatingListUseCase({required this.repository});

  Future<PageableWrapper<RatingEntity>> call(int cursor, int size) async {
    return await repository.loadMyRatingList(cursor, size);
  }
}
