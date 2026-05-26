import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class TurnOffChatNotificationUseCase {
  final ChatRepository repository;

  TurnOffChatNotificationUseCase({required this.repository});

  Future<bool> call(String chatRoomPublicId) async {
    final success = await repository.turnOffChatNotification(chatRoomPublicId);
    return success;
  }
}
