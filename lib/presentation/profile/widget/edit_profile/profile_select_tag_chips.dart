import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ProfileSelectTagChips extends StatelessWidget {
  const ProfileSelectTagChips({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.baseRadius,
        color: isSelected ? AppColors.primary : AppColors.gray20,
      ),
      padding: AppPadding.chip,
      child: Text(
        title,
        style: AppTextStyles.textMedium(
          textColor: isSelected ? AppColors.white : AppColors.gray90,
        ),
      ),
    );
  }
}
