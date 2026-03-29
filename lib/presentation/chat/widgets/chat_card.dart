import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.isMe,
    required this.text,
    this.sendAt,
    this.otherName,
    this.otherProfile,
  });

  final bool isMe;
  final String text;
  final Widget? otherProfile;
  final String? otherName;
  final Duration? sendAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.chatMargin,
      child: isMe ? _card() : _otherCard(),
    );
  }

  Widget _otherCard() => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _profile(),
      AppGap.h16,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$otherName • ${sendAt?.inHours}시간 전",
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
          _card(),
        ],
      ),
    ],
  );

  Widget _profile() => Container(
    width: AppSpacing.s36,
    height: AppSpacing.s36,
    decoration: BoxDecoration(
      borderRadius: AppRadius.circleRadius,
    ),
    clipBehavior: Clip.hardEdge,
    child: otherProfile,
  );

  Widget _card() => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 300),
    child: Card(
      color: isMe ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: isMe ? AppRadius.myChat : AppRadius.otherChat,
      ),
      child: Padding(
        padding: AppPadding.chatPadding,
        child: Text(
          text,
          softWrap: true,
          style: AppTextStyles.textMedium(
            textColor: isMe ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    ),
  );
}
