abstract class RatingRepository {
  Future<bool> ratingChatRoom(String chatRoomPublicId, int star, String comment, List<String> tags);
}
