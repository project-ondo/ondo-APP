import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class BlockChatRoomUseCase {
  final ChatRepository repository;

  BlockChatRoomUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId) async {
    return await repository.blockChatRoom(chatRoomPublicId);
  }
}
