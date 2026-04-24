import 'package:ondo/domain/entities/chat/chat_message_entity.dart';
import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class LoadChatRoomMessageUseCase {
  final ChatRepository repository;

  LoadChatRoomMessageUseCase({required this.repository});

  Future<List<ChatMessageEntity>> call({
    required String chatRoomPublicId,
    required int cursor,
    required int size,
  }) async {
    return await repository.loadChatRoomMessages(
      chatRoomPublicId,
      cursor,
      size,
    );
  }
}
