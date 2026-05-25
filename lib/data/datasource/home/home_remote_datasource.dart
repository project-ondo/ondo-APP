import 'dart:async';
import 'dart:convert';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class HomeRemoteDatasource {
  final AuthClient client;

  HomeRemoteDatasource({required this.client});

  Future<Map?> loadRecommendPostList(ListRequestModelBasePage model) async {
    final log = ApiConstants(logName: "홈 추천 게시물 조회");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.post}/recommend${model.toQueryParameter()}"),
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
