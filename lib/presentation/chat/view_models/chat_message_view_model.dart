import 'package:ondo/domain/entities/chat/chat_message_entity.dart';

class ChatMessageViewModel {
  final int? messageId;
  final bool isMe;
  final String? profileImageKey;
  final String messageType;
  final String content;
  final DateTime createdAt;

  ChatMessageViewModel({
    this.messageId,
    required this.messageType,
    required this.content,
    required this.createdAt,
    required this.isMe,
    required this.profileImageKey,
  });

  /// HTTP 히스토리 메시지 → ViewModel
  factory ChatMessageViewModel.fromJsonChatMessageEntity(
    ChatMessageEntity entity,
  ) => ChatMessageViewModel(
    messageId: entity.messageId,
    messageType: entity.messageType,
    content: entity.content,
    createdAt: entity.createdAt,
    isMe: false,
    //TODO : 내 프로필 정보을 저장한 storage를 두고 비교하여 구분
    profileImageKey:
        null, //TODO : 내 프로필 정보를 저장한 storage를 두고 key를 불러오거나, sendorId를 가지고 이미지를 조회하여 불러옴,
  );

  /// WebSocket 실시간 수신 메시지 → ViewModel
  ///
  /// 서버 payload:
  /// ```json
  /// { "messageId", "roomId", "senderId", "messageType", "content", "createdAt" }
  /// ```
  factory ChatMessageViewModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageViewModel(
        messageId: (json['messageId'] as num?)?.toInt(),
        messageType: json['messageType'] as String? ?? 'TEXT',
        content: json['content'] as String? ?? '',
        createdAt:
            DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        isMe: false, // TODO: senderId와 내 ID 비교로 구분 예정
        profileImageKey: null, // TODO: senderId로 프로필 이미지 조회 예정
      );
}
