import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class CreateChatRoomUseCase {
  final ChatRepository repository;

  CreateChatRoomUseCase({required this.repository});

  Future<String> call(String usersPublicId) async {
    return await repository.createChatRoom(usersPublicId);
  }
}
