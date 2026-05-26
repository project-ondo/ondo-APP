import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class LoadMyRatingListUseCase {
  final RatingRepository repository;

  LoadMyRatingListUseCase({required this.repository});

  Future<List<RatingEntity>> call(int cursor, int size) async {
    final res = await repository.loadMyRatingList(cursor, size);
    return res;
  }
}
