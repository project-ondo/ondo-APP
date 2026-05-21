import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class CancelBlockChatRoomUseCase {
  final ChatRepository repository;

  CancelBlockChatRoomUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId) async {
    return await repository.cancelBlockChatRoom(chatRoomPublicId);
  }
}
