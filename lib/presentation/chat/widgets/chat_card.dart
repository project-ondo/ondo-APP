import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.isMe, required this.text});

  final bool isMe;
  final String text;


  static final Radius round = Radius.circular(8);

  static final BorderRadius meBorder = BorderRadius.only(
    topLeft: round,
    topRight: round,
    bottomLeft: round,
  );
  static final BorderRadius otherBorder = BorderRadius.only(
    topLeft: round,
    topRight: round,
    bottomRight: round,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isMe ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: isMe ? meBorder : otherBorder,
      ),
      child: Padding(
        padding: AppPadding.chatCard,
        child: Text(
          text,
          style: AppTextStyles.textMedium(
            textColor: isMe ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
