import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/domain/notification/notification_entity.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notificationInfo;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    this.onTap,
    required this.notificationInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomProfileCircle(
            radius: AppSpacing.s24,
            //TODO : 서버 프로필 이미지 api 개발 이후에 수정
            imageUrl: null,
          ),
          AppGap.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                Text(
                  notificationInfo.body,
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
        notificationInfo.title,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Spacer(),
      Text(
        AppDateUtils.timeAgo(notificationInfo.createdAt),
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
    ],
  );
}
