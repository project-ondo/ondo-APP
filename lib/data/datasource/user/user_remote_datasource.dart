import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_search_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class UserRemoteDatasource {
  final BaseClient client;

  UserRemoteDatasource({required this.client});

  Future<Map?> search(BaseSearchRequestModel model) async {
    final log = ApiConstants(logName: "유저 검색");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.users}/search?${model.toQueryString()}"),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"] == true);
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
