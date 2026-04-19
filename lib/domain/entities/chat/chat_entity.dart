import 'package:ondo/data/models/chat/response/chat_model.dart';

class ChatEntity {
  final String roomId;
  final String opponentPublicId;
  final String opponentDisplayName;
  final String opponentProfileImageKey;
  final bool opponentOnline;
  final int unreadCount;
  final String lastMessagePreview;
  final bool muted;
  final DateTime lastMessageAt;

  ChatEntity({
    required this.roomId,
    required this.opponentPublicId,
    required this.opponentDisplayName,
    required this.opponentProfileImageKey,
    required this.opponentOnline,
    required this.unreadCount,
    required this.lastMessagePreview,
    required this.muted,
    required this.lastMessageAt,
  });

  factory ChatEntity.fromChatModel(ChatModel model) => ChatEntity(
    roomId: model.roomId,
    opponentPublicId: model.opponentPublicId,
    opponentDisplayName: model.opponentDisplayName,
    opponentProfileImageKey: model.opponentProfileImageKey,
    opponentOnline: model.opponentOnline,
    unreadCount: model.unreadCount,
    lastMessagePreview: model.lastMessagePreview,
    muted: model.muted,
    lastMessageAt: DateTime.parse(model.lastMessageAt),
  );
}
