import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

typedef SelectTag = void Function(bool isSelect);

class CustomTagCard extends StatefulWidget {
  final String label;
  final SelectTag? onTap;

  const CustomTagCard({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  State<CustomTagCard> createState() => _CustomTagCardState();
}

class _CustomTagCardState extends State<CustomTagCard> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isFocus ? AppColors.white : AppColors.gray90;
    final backgroundColor = isFocus ? AppColors.primary : AppColors.gray20;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        isFocus = !isFocus;
        widget.onTap?.call(isFocus);
        setState(() {});
      },
      child: Container(
        padding: AppPadding.chip,
        decoration: BoxDecoration(
          borderRadius: AppRadius.baseRadius,
          color: backgroundColor,
        ),
        child: Text(
          widget.label,
          style: AppTextStyles.textMedium(
            textColor: foregroundColor,
          ),
        ),
      ),
    );
  }
}
