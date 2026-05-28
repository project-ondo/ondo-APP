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
  ///
  /// TODO: senderId(int)와 myPublicId(String UUID)는 타입이 달라 직접 비교 불가.
  ///       서버가 senderPublicId(String)를 응답에 추가하거나, myUserId(int)를 별도
  ///       저장하는 후속 작업(#200 이후) 시 isMe 처리 완성 예정.
  factory ChatMessageViewModel.fromJsonChatMessageEntity(
    ChatMessageEntity entity,
  ) => ChatMessageViewModel(
    messageId: entity.messageId,
    messageType: entity.messageType,
    content: entity.content,
    createdAt: entity.createdAt,
    isMe: false,
    profileImageKey: null, //TODO : senderId로 프로필 이미지 조회 예정
  );

  /// WebSocket 실시간 수신 메시지 → ViewModel
  ///
  /// 서버 payload:
  /// ```json
  /// { "messageId", "roomId", "senderId", "messageType", "content", "createdAt" }
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
        profileImageKey: null, // TODO: senderId로 프로필 이미지 조회 예정
      );
}
