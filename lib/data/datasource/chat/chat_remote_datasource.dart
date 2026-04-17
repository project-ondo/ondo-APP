import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class ChatRemoteDatasource {
  final BaseClient client;

  ChatRemoteDatasource({required this.client});

  Future<Map?> loadMyChatRoomList(BaseListRequestModel model) async {
    final log = ApiConstants(logName: "내 채팅 목록");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.chats}/rooms${model.toQueryParameter()}"),
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
