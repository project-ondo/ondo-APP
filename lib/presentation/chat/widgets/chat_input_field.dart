import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';

class ChatInputField extends GetView<ChatRoomController> {
  const ChatInputField({super.key, required this.roomId});

  final String roomId;

  @override
  String? get tag => roomId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.textField,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGray,
            offset: const Offset(0, -16),
            blurRadius: 16.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.textController,
              hintText: "메세지 내용을 입력해 주세요",
              maxLines: 2,
              onChanged: controller.onTypingChanged,
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
