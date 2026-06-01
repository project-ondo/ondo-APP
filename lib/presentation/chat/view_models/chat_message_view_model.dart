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
  /// { "messageId", "roomId", "senderPublicId", "messageType", "content", "createdAt" }
  /// ```
  /// [myPublicId]를 전달하면 다중 기기 로그인 환경에서도 본인 메시지를 올바르게 판별한다.
  factory ChatMessageViewModel.fromJson(
    Map<String, dynamic> json, {
    String? myPublicId,
  }) =>
      ChatMessageViewModel(
        messageId: (json['messageId'] as num?)?.toInt(),
        messageType: json['messageType'] as String? ?? 'TEXT',
        content: json['content'] as String? ?? '',
        createdAt:
            AppDateUtils.tryParseUtc(json['createdAt'] as String?) ??
            DateTime.now(),
        isMe: myPublicId != null &&
            json['senderPublicId'] != null &&
            json['senderPublicId'] == myPublicId,
        profileImageKey: null, // TODO: senderPublicId로 프로필 이미지 조회 예정
      );
}
