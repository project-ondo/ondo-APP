import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/controllers/chat_controller.dart';
import 'package:ondo/presentation/chat/widgets/chat_card.dart';
import 'package:ondo/presentation/chat/widgets/chat_input_field.dart';
import 'package:ondo/presentation/chat/widgets/chat_review_dialog.dart';

void main () {
  runApp(MaterialApp(home: ChatRoomScreen(),));
}


class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatController _controller = Get.put(ChatController());

  void _showReviewDialog() => showDialog(
    context: context,
    builder: (context) => ChatReviewDialog(),
  );

  //void _showQuitAlertDialog () {} TODO: 이전의 pr에 정의된 CustomAlertDialog가 develop에 merge 되면 이후 추가하도록 하겠습니다.

  void _report() {}

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
          ChatInputField(),
        ],
      ),
    );
  }

  Widget _body() => Container(
    width: double.maxFinite,
    color: AppColors.background,
    child: Obx(
      () => !_controller.isNewChat.value ? _chatList() : _noChatIcon(),
    ),
  );

  Widget _chatList() => ListView.builder(
    itemBuilder: (context, index) {
      final chat = _controller.chats[index];
      if (chat.isMe) {
        return _myChat(chat.comment);
      }
      return _otherChat(chat.comment);
    },
    itemCount: _controller.chats.length,
  );

  Widget _myChat(String text) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ChatCard(isMe: true, text: text),
    ],
  );

  Widget _otherChat(String text) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ChatCard(
        isMe: false,
        text: text,
        otherName: "김유찬",
        otherProfile: SvgPicture.asset(AppIcon.defaultProfile.path),
        sendAt: Duration(hours: 3),
      ),
    ],
  );

  Widget _noChatIcon() => Column(
    children: [
      Placeholder(
        child: SvgPicture.asset(
          AppIcon.message.path,
        ),
      ),
      Spacer(),
      Image.asset(AppIcon.message.path),
      Text(
        "아직 채팅이 시작되지 않았어요",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
      Spacer(),
    ],
  );

  Widget _topBar() => CustomBackButton(
    moreOptions: true,
    useUserProfile: true,
    userInfo: (
      SvgPicture.asset(
        AppIcon.defaultProfile.path,
      ),
      "김유찬",
    ),
    itemBuilder: (context) => [
      _customPopupMenu(
        "커피챗 종료하기",
        _showReviewDialog,
      ),
      _customPopupMenu(
        "신고하기",
        _report,
      ),
    ],
  );

  PopupMenuEntry<String> _customPopupMenu(
    String text,
    VoidCallback action,
  ) => PopupMenuItem(
    height: double.minPositive,
    //padding: AppPadding., TODO: 이전의 pr에 정의된 popupManu (AppPadding)가 develop에 merge 되면 이후 추가하도록 하겠습니다.
    onTap: action,
    child: Text(
      text,
      style: AppTextStyles.caption(textColor: AppColors.gray90),
    ),
  );
}
