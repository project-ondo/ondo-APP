import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_search_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class SearchRemoteDatasource {
  final BaseClient client;

  SearchRemoteDatasource({required this.client});

  Future<Map?> searchPost(BaseSearchRequestModel model) async {
    final log = ApiConstants(logName: "게시물 검색");

    try {
      final res = await client.get(
        Uri.parse(
          "${ApiConstants.users}/search",
        ).replace(queryParameters: model.toQueryParametersAll()),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"]);
      log.successLog(body["message"]);

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
