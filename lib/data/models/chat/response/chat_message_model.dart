import 'package:ondo/data/models/base/response/base_model.dart';

class ChatMessageModel extends BaseModel {
  final int messageId;
  final String roomId;
  final String? senderPublicId;
  final String? senderDisplayName;
  final String? senderProfileImageKey;
  final String messageType;
  final String content;
  final String createdAt;

  ChatMessageModel({
    required this.messageId,
    required this.roomId,
    required this.senderPublicId,
    required this.senderDisplayName,
    required this.senderProfileImageKey,
    required this.messageType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map json) => ChatMessageModel(
    messageId: (json["messageId"] as num).toInt(),
    roomId: json["roomId"] as String,
    senderPublicId: json["senderPublicId"] as String?,
    senderDisplayName: json["senderDisplayName"] as String?,
    senderProfileImageKey: json["senderProfileImageKey"] as String?,
    messageType: json["messageType"] as String? ?? 'TEXT',
    content: json["content"] as String? ?? '',
    createdAt: json["createdAt"] as String? ?? '',
  );

  @override
  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "roomId": roomId,
    "senderPublicId": senderPublicId,
    "senderDisplayName": senderDisplayName,
    "senderProfileImageKey": senderProfileImageKey,
    "messageType": messageType,
    "content": content,
    "createdAt": createdAt,
  };
}
