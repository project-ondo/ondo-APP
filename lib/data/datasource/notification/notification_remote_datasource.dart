import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class NotificationRemoteDatasource {
  final BaseClient client;

  NotificationRemoteDatasource({required this.client});

  Future<Map?> loadMyNotificationList(BaseListRequestModel model) async {
    final log = ApiConstants(logName: "내 알림 목록");

    try {
      final res = await client.get(
        Uri.parse(ApiConstants.notification + model.toQueryParameter()),
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
