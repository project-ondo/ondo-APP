import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

typedef SelectTag = void Function(bool isSelect);

class CustomTagCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final SelectTag? onTap;

  const CustomTagCard({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? AppColors.white : AppColors.gray90;
    final backgroundColor = isSelected ? AppColors.primary : AppColors.gray20;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap?.call(!isSelected),
      child: Container(
        padding: AppPadding.chip,
        decoration: BoxDecoration(
          borderRadius: AppRadius.baseRadius,
          color: backgroundColor,
        ),
        child: Text(
          label,
          style: AppTextStyles.textMedium(
            textColor: foregroundColor,
          ),
        ),
      ),
    );
  }
}
