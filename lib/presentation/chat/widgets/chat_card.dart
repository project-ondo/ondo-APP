import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/utils/app_date_utils.dart';

import '../../../core/design_system/components/custom_profile_circle.dart';

class ChatCard extends StatelessWidget {
  const ChatCard.other({
    super.key,
    required this.text,
    required this.sendAt,
    required this.otherName,
    required this.profileImgUrl,
  }) : isMe = false,
       isRead = false;

  const ChatCard.my({
    super.key,
    required this.text,
    required this.isRead,
  }) : isMe = true,
       sendAt = null,
       otherName = null,
       profileImgUrl = null;

  final bool isMe;
  final String text;

  final bool isRead;
  final String? profileImgUrl;
  final String? otherName;
  final DateTime? sendAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.chatMargin,
      child: isMe ? _myCard() : _otherCard(),
    );
  }

  Widget _myCard() => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (isRead)
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            '읽음',
            style: AppTextStyles.caption(textColor: AppColors.primary),
          ),
        ),
      _card(),
    ],
  );

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
            "$otherName • ${AppDateUtils.timeAgo(sendAt)}",
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
          _card(),
        ],
      ),
    ],
  );

  Widget _profile() => profileImgUrl != null
      ? CustomProfileCircle(
          radius: AppSpacing.s36,
          imageUrl: profileImgUrl,
        )
      : SizedBox.shrink();

  Widget _card() => Container(
    decoration: BoxDecoration(
      color: isMe ? AppColors.primary : AppColors.white,
      borderRadius: isMe ? AppRadius.myChat : AppRadius.otherChat,
    ),
    padding: AppPadding.chatPadding,
    child: Text(
      text,
      softWrap: true,
      style: AppTextStyles.textMedium(
        textColor: isMe ? AppColors.white : AppColors.black,
      ),
    ),
  );
}
