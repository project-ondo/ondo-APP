import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';

class ChatInputField extends GetView<ChatRoomController> {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.textField,
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.textController,
              hintText: "메세지 내용을 입력해 주세요",
              maxLines: 2,
              onSubmitted: controller.sendChat,
            ),
          ),
          AppGap.h16,
          _sendButton(),
        ],
      ),
    );
  }

  Widget _sendButton() => GestureDetector(
    onTap: () => controller.sendChat(controller.textController.text),
    child: SvgPicture.asset(
      AppIcon.send.path,
      width: AppSpacing.s32,
      height: AppSpacing.s18,
    ),
  );
}
