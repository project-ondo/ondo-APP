import 'package:ondo/data/models/base/response/base_model.dart';

class ChatMessageModel extends BaseModel {
  final int messageId;
  final String roomId;
  final int senderId;
  final String messageType;
  final String content;
  final String createdAt;

  ChatMessageModel({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map json) => ChatMessageModel(
    messageId: json["messageId"],
    roomId: json["roomId"],
    senderId: json["senderId"],
    messageType: json["messageType"],
    content: json["content"],
    createdAt: json["createdAt"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "roomId": roomId,
    "senderId": senderId,
    "messageType": messageType,
    "content": content,
    "createdAt": createdAt,
  };
}
