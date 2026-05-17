import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class RatingChatRoomUseCase {
  final RatingRepository repository;

  RatingChatRoomUseCase({required this.repository});

  Future<bool> call({
    required String chatRoomPublicId,
    required int star,
    required String comment,
    required List<String> tags,
  }) async {
    final res = await repository.ratingChatRoom(
      chatRoomPublicId,
      star,
      comment,
      tags
    );
    return res;
  }
}
