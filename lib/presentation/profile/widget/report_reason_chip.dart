import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ReportReasonChip extends StatelessWidget {
  const ReportReasonChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.chip,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.gray20,
          borderRadius: AppRadius.baseRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.textMedium(
            textColor: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
