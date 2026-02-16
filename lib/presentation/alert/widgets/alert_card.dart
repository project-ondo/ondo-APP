import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class AlertCard extends StatelessWidget {
  final String alertType;
  final Duration sendAt;
  final String? comment;
  final String profileImage;

  const AlertCard({
    super.key,
    required this.profileImage,
    required this.alertType,
    required this.sendAt,
    this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _profile(),
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
    );
  }

  final double _profileSize = 24;

  Widget _profile() => Container(
    height: _profileSize,
    width: _profileSize,
    decoration: BoxDecoration(
      borderRadius: AppRadius.circleRadius,
    ),
    child: SvgPicture.asset(profileImage),
  );

  Widget _title() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        alertType,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
      ),
      Text(
        "${sendAt.inHours}시간 전",
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
    ],
  );
}