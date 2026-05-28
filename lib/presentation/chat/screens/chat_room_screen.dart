import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';
import 'package:ondo/presentation/chat/view_models/chat_message_view_model.dart';
import 'package:ondo/presentation/chat/widgets/chat_card.dart';
import 'package:ondo/presentation/chat/widgets/chat_input_field.dart';

class ChatRoomScreen extends GetView<ChatRoomController> {
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  String? get tag => roomId;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
          ChatInputField(
            roomId: roomId,
          ),
        ],
      ),
    );
  }

  Widget _body() => Container(
    width: double.maxFinite,
    color: AppColors.background,
    child: Column(
      children: [
        Expanded(
          child: Obx(() {
            final lastReadId = controller.opponentLastReadMessageId.value;
            final opponentProfileUrl = controller.opponentProfileImageUrl.value;
            return controller.viewChatList.isNotEmpty
                ? _chatList(lastReadId, opponentProfileUrl)
                : _noChatIcon();
          }),
        ),
        Obx(
          () => controller.isOpponentTyping.value
              ? _typingIndicator()
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );

  Widget _chatList(int lastReadId, String opponentProfileUrl) => ListView.builder(
    controller: controller.scrollController,
    reverse: true,
    itemBuilder: (context, index) {
      final chat = controller.viewChatList[index];
      return _chatBubble(chat, lastReadId, opponentProfileUrl);
    },
    itemCount: controller.viewChatList.length,
  );

  Widget _chatBubble(ChatMessageViewModel chat, int lastReadId, String opponentProfileUrl) {
    if (chat.isMe) {
      final isRead = chat.messageId != null && chat.messageId! <= lastReadId;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [ChatCard.my(text: chat.content, isRead: isRead)],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ChatCard.other(
          text: chat.content,
          otherName: controller.opponentDisplayName,
          profileImgUrl: opponentProfileUrl.isEmpty ? null : opponentProfileUrl,
          sendAt: chat.createdAt,
        ),
      ],
    );
  }

  Widget _typingIndicator() => Padding(
    padding: AppPadding.chatMargin,
    child: Row(
      children: [
        Text(
          '상대방이 입력 중...',
          style: AppTextStyles.caption(textColor: AppColors.gray60),
        ),
      ],
    ),
  );

  Widget _noChatIcon() => Column(
    children: [
      Spacer(),
      Image.asset(AppIcon.message.path),
      Text(
        "아직 채팅이 시작되지 않았어요",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
      Spacer(),
    ],
  );

  Widget _topBar() => Obx(
    () => CustomBackButton(
      moreOptions: true,
      useUserProfile: true,
      backAction: controller.backChatRoom,
      subtitle: controller.isOpponentViewing.value
          ? '채팅 중'
          : controller.isOpponentOnline.value
          ? '온라인'
          : null,
      userInfo: (
        CustomProfileCircle(
          radius: AppSpacing.s24,
          imageUrl: controller.opponentProfileImageUrl.value.isEmpty
              ? null
              : controller.opponentProfileImageUrl.value,
        ),
        controller.opponentDisplayName,
      ),
      itemBuilder: (context) => [
        _customPopupMenu(
          "커피챗 종료하기",

          ///종료 알림창 표시
          controller.quitChat,
        ),
        _customPopupMenu(
          "신고하기",
          //신고 기능
          () {
            //TODO : 신고 기능
          },
        ),
      ],
    ),
  );

  PopupMenuEntry<String> _customPopupMenu(
    String text,
    VoidCallback action,
  ) => PopupMenuItem(
    height: double.minPositive,
    padding: AppPadding.popupManuButton,
    onTap: action,
    child: Text(
      text,
      style: AppTextStyles.caption(textColor: AppColors.gray90),
    ),
  );
}
