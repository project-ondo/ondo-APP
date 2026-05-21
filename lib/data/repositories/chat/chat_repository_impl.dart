import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/chat/request/chat_message_list_request_model.dart';
import 'package:ondo/data/models/chat/response/chat_message_model.dart';
import 'package:ondo/data/models/chat/response/chat_model.dart';
import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/repositories/chat/chat_repository.dart';

import '../../datasource/chat/chat_remote_datasource.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ChatEntity>> loadMyChatRoomList(int size, int page) async {
    final model = ListRequestModel(size: size, page: page);

    final json = await remoteDatasource.loadMyChatRoomList(model);

    if (json == null) return [];

    final res = ChatDataModel.fromJson(json);

    return res.content
        .map(
          (e) => ChatEntity.fromChatModel(e),
        )
        .toList();
  }

  @override
  Future<String> createChatRoom(String usersPublicId) async {
    final json = await remoteDatasource.createChatRoom(usersPublicId);
    if (json == null) return "";
    return json["roomId"] ?? "";
  }

  @override
  Future<bool> blockChatRoom(String chatRoomPublicId) async {
    return await remoteDatasource.blockChatRoom(chatRoomPublicId);
  }

  @override
  Future<bool> cancelBlockChatRoom(String chatRoomPublicId) async {
    return await remoteDatasource.cancelBlockChatRoom(chatRoomPublicId);
  }

  @override
  Future<PageableWrapper<ChatMessageEntity>> loadChatRoomMessages(
    String chatRoomPublicId,
    int cursor,
    int size,
  ) async {
    final model = ChatMessageListRequestModel(size: size, cursor: cursor);
    final json = await remoteDatasource.loadChatRoomMessages(
      chatRoomPublicId,
      model,
    );

    if (json == null) return PageableWrapper(pages: [], nextCursor: null);

    final dataModelList =
        (json["items"] as List?)
            ?.map(
              (e) => ChatMessageModel.fromJson(e),
            )
            .toList() ??
        [];

    return PageableWrapper(
      pages: dataModelList
          .map((e) => ChatMessageEntity.fromJsonChatMessageModel(e))
          .toList(),
      nextCursor: json["nextCursor"],
    );
  }

  @override
  Future<bool> readChatMessage(
    String chatRoomPublicId,
    int lastReadMessageId,
  ) async {
    final res = await remoteDatasource.readChatMessage(
      chatRoomPublicId,
      lastReadMessageId,
    );

    return res;
  }

  @override
  Future<bool> deleteChatRoom(String chatRoomPublicId) async {
    final res = await remoteDatasource.deleteChatRoom(chatRoomPublicId);
    return res;
  }

  @override
  Future<bool> turnOnChatNotification(String chatRoomPublicId) async {
    final res = await remoteDatasource.turnOnChatNotification(chatRoomPublicId);
    return res;
  }
}
