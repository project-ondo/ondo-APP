import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/chat/request/chat_message_list_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class ChatRemoteDatasource {
  final BaseClient client;

  ChatRemoteDatasource({required this.client});

  Future<Map?> loadMyChatRoomList(ListRequestModel model) async {
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

  Future<Map?> createChatRoom(String usersPublicId) async {
    final log = ApiConstants(logName: "채팅방 생성");

    try {
      final res = await client.post(
        Uri.parse("${ApiConstants.chats}/rooms"),
        headers: ApiConstants.baseHeader,
        body: jsonEncode({"targetUserPublicId": usersPublicId}),
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

  Future<bool> blockChatRoom(String chatRoomPublicId) async {
    final log = ApiConstants(logName: "채팅방 차단");

    try {
      final res = await client.put(
        Uri.parse("${ApiConstants.chats}/rooms/$chatRoomPublicId/block"),
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

  Future<bool> cancelBlockChatRoom(String chatRoomPublicId) async {
    final log = ApiConstants(logName: "채팅방 차단 해제");

    try {
      final res = await client.delete(
        Uri.parse("${ApiConstants.chats}/rooms/$chatRoomPublicId/block"),
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

  Future<Map?> loadChatRoomMessages(
    String chatRoomPublicId,
    ChatMessageListRequestModel model,
  ) async {
    final log = ApiConstants(logName: "채팅 메시지 목록 조회");

    try {
      final res = await client.get(
        Uri.parse(
          "${ApiConstants.chats}/rooms/$chatRoomPublicId/messages${model.toQueryParameter()}",
        ),
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

  Future<bool> readChatMessage(
    String chatRoomPublicId,
    num lastReadMessageId,
  ) async {
    final log = ApiConstants(logName: "채팅방 읽음 처리");

    try {
      final res = await client.patch(
        Uri.parse(
          "${ApiConstants.chats}/rooms/$chatRoomPublicId/read?lastReadMessageId=$lastReadMessageId",
        ),
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
}
