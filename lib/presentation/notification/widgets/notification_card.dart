import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class NotificationCard extends StatelessWidget {
  final String notificationType;
  final Duration sendAt;
  final String? comment;
  final String? profileImg;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    this.profileImg,
    required this.notificationType,
    required this.sendAt,
    this.comment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomProfileCircle(
            radius: AppSpacing.s24,
            imageUrl: profileImg,
          ),
          AppGap.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                if (comment != null)
                  Text(
                    comment!,
                    style: AppTextStyles.caption(textColor: AppColors.gray60),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() => Row(
    children: [
      Text(
        notificationType,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Spacer(),
      Text(
        "${sendAt.inHours}시간 전",
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
    ],
  );
}
