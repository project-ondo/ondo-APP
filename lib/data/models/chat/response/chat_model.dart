import 'package:ondo/data/models/base/response/base_data_model.dart';
import 'package:ondo/data/models/base/response/base_model.dart';

class ChatDataModel extends BaseDataModel<ChatModel> {
  ChatDataModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.last,
  });

  factory ChatDataModel.fromJson(Map json) => ChatDataModel(
    content: (json["content"] as List)
        .map(
          (e) => ChatModel.fromJson(e),
        )
        .toList(),
    page: json["page"],
    size: json["size"],
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    last: json["last"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "content": content
        .map(
          (e) => e.toJson(),
        )
        .toList(),
    "page": page,
    "size": size,
    "totalElements": totalElements,
    "totalPages": totalPages,
    "last": last,
  };
}

class ChatModel extends BaseModel {
  final String roomId;
  final String opponentPublicId;
  final String opponentDisplayName;
  final String opponentProfileImageKey;
  final bool opponentOnline;
  final int unreadCount;
  final String lastMessagePreview;
  final bool muted;
  final String lastMessageAt;

  ChatModel({
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

  factory ChatModel.fromJson(Map json) => ChatModel(
    roomId: json["roomId"],
    opponentPublicId: json["opponentPublicId"],
    opponentDisplayName: json["opponentDisplayName"],
    opponentProfileImageKey: json["opponentProfileImageKey"],
    opponentOnline: json["opponentOnline"],
    unreadCount: json["unreadCount"],
    lastMessagePreview: json["lastMessagePreview"],
    muted: json["muted"],
    lastMessageAt: json["lastMessageAt"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "opponentPublicId": opponentPublicId,
    "opponentDisplayName": opponentDisplayName,
    "opponentProfileImageKey": opponentProfileImageKey,
    "opponentOnline": opponentOnline,
    "unreadCount": unreadCount,
    "lastMessagePreview": lastMessagePreview,
    "muted": muted,
    "lastMessageAt": lastMessageAt,
  };
}
