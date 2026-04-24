import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> loadMyChatRoomList(int size, int page);

  Future<List<ChatMessageEntity>> loadChatRoomMessages(
    String chatRoomPublicId,
    int cursor,
    int size,
  );

  Future<String> createChatRoom(String usersPublicId);

  Future<bool> blockChatRoom(String chatRoomPublicId);

  Future<bool> cancelBlockChatRoom(String chatRoomPublicId);
}
