import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class TurnOnChatNotificationUseCase {
  final ChatRepository repository;

  TurnOnChatNotificationUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId) async {
    final success = await repository.turnOnChatNotification(chatRoomPublicId);
    return success;
  }
}
