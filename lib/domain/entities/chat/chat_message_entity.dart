import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/data/models/chat/response/chat_message_model.dart';

class ChatMessageEntity {
  final int messageId;
  final String roomId;
  final String? senderPublicId;
  final String? senderDisplayName;
  final String? senderProfileImageKey;
  final String messageType;
  final String content;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.messageId,
    required this.roomId,
    required this.senderPublicId,
    required this.senderDisplayName,
    required this.senderProfileImageKey,
    required this.messageType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageEntity.fromJsonChatMessageModel(ChatMessageModel model) =>
      ChatMessageEntity(
        messageId: model.messageId,
        roomId: model.roomId,
        senderPublicId: model.senderPublicId,
        senderDisplayName: model.senderDisplayName,
        senderProfileImageKey: model.senderProfileImageKey,
        messageType: model.messageType,
        content: model.content,
        createdAt: AppDateUtils.parseUtc(model.createdAt),
      );
}
