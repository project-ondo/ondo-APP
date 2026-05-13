import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class ReadChatMessageUseCase {
  final ChatRepository repository;

  ReadChatMessageUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId, int lastReadMessageId) async {
    return await repository.readChatMessage(
      chatRoomPublicId,
      lastReadMessageId,
    );
  }
}
