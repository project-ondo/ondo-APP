import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const TagChip({
    super.key,
    required this.tag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.tagChip,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.s8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: AppTextStyles.textMedium(textColor: AppColors.white),
          ),
          AppGap.h8,
          GestureDetector(
            onTap: onRemove,
            child: Image.asset(
              AppIcon.close.path,
              color: AppColors.white,
              width: AppSpacing.s14,
              height: AppSpacing.s14,
            ),
          ),
        ],
      ),
    );
  }
}
