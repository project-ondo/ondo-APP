import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CustomTagCard extends StatelessWidget {
  final String tag;
  final Color? color;
  final bool isSelect;

  const CustomTagCard({
    super.key,
    required this.tag,
    this.color,
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        color: isSelect ? AppColors.primary : color ?? AppColors.white,
      ),
      child: Text(
        tag,
        style: AppTextStyles.textMedium(
          textColor: isSelect ? AppColors.white : AppColors.gray90,
        ),
      ),
    );
  }
}
