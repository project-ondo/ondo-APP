import 'package:ondo/data/datasource/rating/rating_remote_datasource.dart';
import 'package:ondo/data/models/rating/request/rating_chat_room_model.dart';
import 'package:ondo/domain/repositories/rating/rating_repository.dart';

class RatingRepositoryImpl extends RatingRepository {
  final RatingRemoteDatasource remoteDatasource;

  RatingRepositoryImpl({required this.remoteDatasource});

  @override
  Future<bool> ratingChatRoom(
    String chatRoomPublicId,
    int star,
    String comment,
    List<String> tags,
  ) async {
    final model = RatingChatRequestModel(stars: star, comment: comment, tags: tags);
    final res = await remoteDatasource.ratingChatRoom(
      chatRoomPublicId,
      model,
    );
    return res;
  }
}
