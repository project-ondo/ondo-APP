import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ActivityStateCard extends StatelessWidget {
  const ActivityStateCard({
    super.key,
    required this.name,
    required this.currentState,
  });

  final String name;
  final String currentState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        borderRadius: AppRadius.baseRadius,
        color: AppColors.gray20,
      ),
      child: Column(
        children: [
          Text(
            name,
            style: AppTextStyles.textMedium(textColor: AppColors.gray60),
          ),
          AppGap.v10,
          Text(
            currentState,
            style: AppTextStyles.textMedium(textColor: AppColors.gray90),
          ),
        ],
      ),
    );
  }
}
