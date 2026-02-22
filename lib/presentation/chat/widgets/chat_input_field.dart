import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/chat/controllers/chat_controller.dart';

class ChatInputField extends StatelessWidget {
  ChatInputField({super.key});

  final ChatController _controller = Get.find<ChatController>();

  void _send() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.textField,
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _controller.textEditingController,
              hintText: "메세지 내용을 입력해 주세요",
              maxLines: 2,
            ),
          ),
          AppGap.h16,
          _sendButton(),
        ],
      ),
    );
  }

  Widget _sendButton() => GestureDetector(
    onTap: _send,
    child: SvgPicture.asset(
      AppIcon.send.path,
      width: 36,
      height: 18,
    ),
  );
}
