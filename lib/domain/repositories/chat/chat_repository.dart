import 'package:ondo/domain/entities/base/pageable_wrapper.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/entities/chat/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> loadMyChatRoomList(int size, int page);

  Future<PageableWrapper<ChatMessageEntity>> loadChatRoomMessages(
    String chatRoomPublicId,
    int cursor,
    int size,
  );

  Future<String> createChatRoom(String usersPublicId);

  Future<bool> blockChatRoom(String chatRoomPublicId);

  Future<bool> cancelBlockChatRoom(String chatRoomPublicId);

  Future<bool> readChatMessage(String chatRoomPublicId, int lastReadMessageId);

  Future<bool> deleteChatRoom(String chatRoomPublicId);

  Future<bool> turnOnChatNotification(String chatRoomPublicId);

  Future<bool> turnOffChatNotification(String chatRoomPublicId);
}
