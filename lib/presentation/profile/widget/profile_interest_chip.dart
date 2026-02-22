import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ProfileInterestChip extends StatelessWidget {
  const ProfileInterestChip({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: AppRadius.baseRadius,
      ),
      child: Text(
        name,
        style: AppTextStyles.textMedium(
          textColor: AppColors.gray90,
        ),
      ),
    );
  }
}
