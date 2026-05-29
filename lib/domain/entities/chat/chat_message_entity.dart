import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/data/models/chat/response/chat_message_model.dart';

class ChatMessageEntity {
  final int messageId;
  final String roomId;
  final int senderId;
  final String messageType;
  final String content;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageEntity.fromJsonChatMessageModel(ChatMessageModel model) =>
      ChatMessageEntity(
        messageId: model.messageId,
        roomId: model.roomId,
        senderId: model.senderId,
        messageType: model.messageType,
        content: model.content,
        createdAt: AppDateUtils.parseUtc(model.createdAt),
      );
}
