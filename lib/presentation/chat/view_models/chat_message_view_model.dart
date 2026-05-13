import 'package:ondo/domain/entities/chat/chat_message_entity.dart';

class ChatMessageViewModel {
  final bool isMe;
  final String? profileImageKey;
  final String messageType;
  final String content;
  final DateTime createdAt;

  ChatMessageViewModel({
    required this.messageType,
    required this.content,
    required this.createdAt,
    required this.isMe,
    required this.profileImageKey,
  });

  factory ChatMessageViewModel.fromJsonChatMessageEntity(
    ChatMessageEntity entity,
  ) => ChatMessageViewModel(
    messageType: entity.messageType,
    content: entity.content,
    createdAt: entity.createdAt,
    isMe: false,
    //TODO : 내 프로필 정보을 저장한 storage를 두고 비교하여 구분
    profileImageKey:
        null, //TODO : 내 프로필 정보를 저장한 storage를 두고 key를 불러오거나, sendorId를 가지고 이미지를 조회하여 불러옴,
  );
}
