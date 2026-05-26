import 'package:ondo/domain/entities/rating/rating_entity.dart';

abstract class RatingRepository {
  Future<bool> ratingChatRoom(
    String chatRoomPublicId,
    int star,
    String comment,
    List<String> tags,
  );

  Future<List<RatingEntity>> loadOtherRatingList(
    String userPublicId,
    int cursor,
    int size,
  );
}
