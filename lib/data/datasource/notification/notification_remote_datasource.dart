import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class NotificationRemoteDatasource {
  final BaseClient client;

  NotificationRemoteDatasource({required this.client});

  Future<Map?> loadMyNotificationList(ListRequestModel model) async {
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

  Future<int?> loadUnreadNotificationCount() async {
    final log = ApiConstants(logName: "미읽음 알림 개수 조회");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.notification}/unread/count"),
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

  Future<int?> readAllNotification() async {
    final log = ApiConstants(logName: "전체 알림 읽음 처리");

    try {
      final res = await client.post(
        Uri.parse("${ApiConstants.notification}/read/all"),
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
