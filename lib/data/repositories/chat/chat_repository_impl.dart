import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/chat/response/chat_model.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/repositories/chat/chat_repository.dart';

import '../../datasource/chat/chat_remote_datasource.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ChatEntity>> loadMyChatRoomList(int size, int page) async {
    final model = BaseListRequestModel(size: size, page: page);

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
}
