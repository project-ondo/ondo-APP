import 'dart:async';
import 'dart:convert';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class HomeRemoteDatasource {
  final AuthClient client;

  HomeRemoteDatasource({required this.client});

  Future<Map?> loadRecommendPostList(BaseListRequestModel model) async {
    final log = ApiConstants(logName: "홈 추천 게시물 조회");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.posts}/recommend").replace(
          queryParameters: model.toJson(),
        ),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"]);
      log.messageLog(body["message"]);

      if (res.statusCode == 200 && body["success"] == true) {
        return body["data"];
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }
    return null;
  }

  Future<Map?> loadRecommendProfileList(
    BaseListRequestModel model,
  ) async {
    final log = ApiConstants(logName: "홈 추천 사용자 조회");

    try {
      final res = await client.get(
        Uri.parse(
          "${ApiConstants.users}/recommend",
        ).replace(queryParameters: model.toJson()),
      );
      final body = jsonDecode(res.body);

      log.successLog(body["success"]);
      log.messageLog(body["message"]);

      if (res.statusCode == 200 && body["success"] == true) {
        return body["data"];
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }
    return null;
  }
}
