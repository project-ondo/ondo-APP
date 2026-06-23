import 'package:ondo/data/datasource/rating/rating_remote_datasource.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/rating/request/rating_chat_request_model.dart';
import 'package:ondo/data/models/rating/response/rating_model.dart';
import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';
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
    final model = RatingChatRequestModel(
      stars: star,
      comment: comment,
      tags: tags,
    );
    final res = await remoteDatasource.ratingChatRoom(
      chatRoomPublicId,
      model,
    );
    return res;
  }

  @override
  Future<PageableWrapper<RatingEntity>> loadOtherRatingList(
    String userPublicId,
    int cursor,
    int size,
  ) async {
    final model = ListRequestModelBaseCursor(size: size, cursor: cursor);
    final json = await remoteDatasource.getOtherRatingList(userPublicId, model);

    if (json.isEmpty) return PageableWrapper(pages: [], nextCursor: null, hasNext: false);

    final data = RatingDataModel.fromJson(json);
    return PageableWrapper(
      pages: data.items.map((e) => RatingEntity.fromRatingModel(e)).toList(),
      nextCursor: data.nextCursor,
      hasNext: data.hasNext,
    );
  }

  @override
  Future<PageableWrapper<RatingEntity>> loadMyRatingList(int cursor, int size) async {
    final model = ListRequestModelBaseCursor(size: size, cursor: cursor);
    final json = await remoteDatasource.getMyRatingList(model);

    if (json.isEmpty) return PageableWrapper(pages: [], nextCursor: null, hasNext: false);

    final data = RatingDataModel.fromJson(json);
    return PageableWrapper(
      pages: data.items.map((e) => RatingEntity.fromRatingModel(e)).toList(),
      nextCursor: data.nextCursor,
      hasNext: data.hasNext,
    );
  }
}
