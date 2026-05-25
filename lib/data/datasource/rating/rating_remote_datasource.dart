import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/rating/request/rating_chat_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class RatingRemoteDatasource {
  final BaseClient client;

  RatingRemoteDatasource({required this.client});

  Future<bool> ratingChatRoom(
    String chatRoomPublicId,
    RatingChatRequestModel model,
  ) async {
    final log = ApiConstants(logName: "사용자 평점 등록");

    try {
      final res = await client.post(
        Uri.parse("${ApiConstants.rating}/rooms/$chatRoomPublicId"),
        headers: ApiConstants.baseHeader,
        body: jsonEncode(model.toJson()),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"] == true);
      log.messageLog(body["message"]);

      if (res.statusCode == 200 && body["success"] == true) {
        return true;
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }

    return false;
  }

  Future<Map> getOtherRatingList(
    String userPublicId,
    ListRequestModelBaseCursor model,
  ) async {
    final log = ApiConstants(logName: "특정 유저가 받은 평가 목록 조회 서버");

    try {
      final res = await client.get(
        Uri.parse(
          "${ApiConstants.rating}/users/$userPublicId${model.toQueryParameter()}",
        ),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"]);
      log.messageLog(body["message"]);

      if (res.statusCode == 200) {
        return body["data"] ?? {};
      }
    } catch (e) {
      log.errorLog(e);
    }

    return {};
  }
}
