import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';
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
          child: Obx(
            () => controller.viewChatList.isNotEmpty
                ? _chatList()
                : _noChatIcon(),
          ),
        ),
        Obx(
          () => controller.isOpponentTyping.value
              ? _typingIndicator()
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );

  Widget _chatList() => ListView.builder(
    itemBuilder: (context, index) {
      final chat = controller.viewChatList[index];
      if (chat.isMe) {
        return Obx(() {
          final isRead =
              chat.messageId != null &&
              chat.messageId! <= controller.opponentLastReadMessageId.value;
          return _myChat(chat.content, isRead: isRead);
        });
      }
      return _otherChat(chat.content);
    },
    itemCount: controller.viewChatList.length,
  );

  Widget _myChat(String text, {bool isRead = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ChatCard(isMe: true, text: text, isRead: isRead),
    ],
  );

  Widget _otherChat(String text) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      //TODO : chat model 정의 후, 데이터 변경
      ChatCard(
        isMe: false,
        text: text,
        otherName: "김유찬",
        otherProfile: SvgPicture.asset(AppIcon.defaultProfile.path),
        sendAt: Duration(hours: 3),
      ),
    ],
  );

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

  //TODO : chat model 정의 후, 데이터 변경
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
      SvgPicture.asset(
        AppIcon.defaultProfile.path,
      ),
      "김유찬",
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
