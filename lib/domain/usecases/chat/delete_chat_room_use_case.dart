import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class DeleteChatRoomUseCase {
  final ChatRepository repository;

  DeleteChatRoomUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId) async {
    final res = await repository.deleteChatRoom(chatRoomPublicId);
    return res;
  }
}
