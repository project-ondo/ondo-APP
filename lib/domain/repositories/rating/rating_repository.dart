import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';

abstract class RatingRepository {
  Future<bool> ratingChatRoom(
    String chatRoomPublicId,
    int star,
    String comment,
    List<String> tags,
  );

  Future<PageableWrapper<RatingEntity>> loadOtherRatingList(
    String userPublicId,
    int cursor,
    int size,
  );

  Future<PageableWrapper<RatingEntity>> loadMyRatingList(
    int cursor,
    int size,
  );
}
