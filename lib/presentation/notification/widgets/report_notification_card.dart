import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class ReportNotificationCard extends StatelessWidget {
  final String? profileImg;
  final String reason;
  final DateTime restrictAt;
  final Duration restrictDuration;
  final VoidCallback? onTap;

  const ReportNotificationCard({
    super.key,
    this.profileImg,
    required this.reason,
    required this.restrictAt,
    required this.restrictDuration,
    this.onTap,
  });

  String _dateFormat(DateTime date) => "${date.year}-${date.month}-${date.day}";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.card,
        decoration: BoxDecoration(
          borderRadius: AppRadius.baseRadius,
          color: AppColors.redLight,
        ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "신고가 누적되어 커피챗 및 커뮤티니 활동이 제한되었습니다.",
                    style: AppTextStyles.caption(textColor: AppColors.gray90),
                  ),
                  _content(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "시유: $reason",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        "기간: 제한 된 날로부터 ${restrictDuration.inDays}일간: ${_dateFormat(restrictAt)} - ${_dateFormat(restrictAt.add(restrictDuration))}",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
      ),
    ],
  );
}
