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

void main() {
  runApp(
    MaterialApp(
      home: ChatRoomScreen(),
    ),
  );
}

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatController _controller = Get.put(ChatController());

  void _showQuitAlertDialog() {}

  void _report() {}

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
          ChatCard(isMe: true, text: "agfsdfg"),
          ChatInputField(),
        ],
      ),
    );
  }

  Widget _body() => Container(
    width: double.maxFinite,
    color: AppColors.background,
    child: Column(
      children: [
        Expanded(child: _noChatIcon()),
      ],
    ),
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
        _showQuitAlertDialog,
      ),
      _customPopupMenu(
        "신고하기",
        _report,
      ),
    ],
  );

  PopupMenuEntry<String> _customPopupMenu(String text, VoidCallback action) =>
      PopupMenuItem(
        height: double.minPositive,
        //padding: AppPadding., TODO: 이전의 pr이 merge 되면 적용되는 다자인 시스템을 적용할 예정
        onTap: action,
        child: Text(
          text,
          style: AppTextStyles.caption(textColor: AppColors.gray90),
        ),
      );
}
