import 'package:ondo/core/utils/app_date_utils.dart';
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
    ChatMessageEntity entity, {
    String? myPublicId,
  }) => ChatMessageViewModel(
    messageId: entity.messageId,
    messageType: entity.messageType,
    content: entity.content,
    createdAt: entity.createdAt,
    isMe: myPublicId != null &&
        entity.senderPublicId != null &&
        entity.senderPublicId == myPublicId,
    profileImageKey: null, // TODO: senderPublicId로 프로필 이미지 조회 예정
  );

  /// WebSocket 실시간 수신 메시지 → ViewModel
  ///
  /// 서버 payload:
  /// ```json
  /// { "messageId", "roomId", "senderId", "senderPublicId", "messageType", "content", "createdAt" }
  /// ```
  /// 내가 보낸 메시지는 ChatRoomController의 echo 감지(_pendingSentContents)로
  /// 처리되므로 이 factory는 상대방 메시지에만 호출된다 → isMe: false 고정.
  factory ChatMessageViewModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageViewModel(
        messageId: (json['messageId'] as num?)?.toInt(),
        messageType: json['messageType'] as String? ?? 'TEXT',
        content: json['content'] as String? ?? '',
        createdAt:
            AppDateUtils.tryParseUtc(json['createdAt'] as String?) ??
            DateTime.now(),
        isMe: false,
        profileImageKey: null, // TODO: senderPublicId로 프로필 이미지 조회 예정
      );
}
