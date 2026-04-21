import 'package:ondo/domain/entities/chat/chat_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> loadMyChatRoomList(int size, int page);
}
