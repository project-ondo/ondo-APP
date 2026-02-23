import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class ReportAlertCard extends StatelessWidget {
  final String profileImage;
  final String reason;
  final DateTime restrictAt;
  final Duration restrictDuration;

  const ReportAlertCard({
    super.key,
    required this.profileImage,
    required this.reason,
    required this.restrictAt,
    required this.restrictDuration,
  });

  String _dateFormat(DateTime date) => "${date.year}-${date.month}-${date.day}";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.alertReportItem,
      decoration: BoxDecoration(
        borderRadius: AppRadius.baseRadius,
        color: AppColors.redLight,
      ),
      child: Row(
        children: [
          _profile(),

          AppGap.h12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _content() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "시유: $reason",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
      ),
      Text(
        "기간: 제한 된 날로부터 ${restrictDuration.inDays}일간: ${_dateFormat(restrictAt)} - ${_dateFormat(restrictAt.add(restrictDuration))}",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
      ),
    ],
  );
}