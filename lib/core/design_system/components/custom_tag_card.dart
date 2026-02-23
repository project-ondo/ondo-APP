import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CustomTagCard extends StatelessWidget {
  final String tag;
  final Color? color;
  final void Function(String)? onTap;
  final ValueNotifier<bool> isSelect;

  CustomTagCard({
    super.key,
    required this.tag,
    this.color,
    this.onTap,
    bool isSelect = false,
  }) : isSelect = ValueNotifier(isSelect);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isSelect,
      builder: (context, value, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            isSelect.value = !isSelect.value;
            onTap?.call(tag);
          },
          child: Container(
            padding: AppPadding.chip,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelect.value ? AppColors.primary : color ?? AppColors.white,
            ),
            child: Text(
              tag,
              style: AppTextStyles.textMedium(
                textColor: isSelect.value ? AppColors.white : AppColors.gray90,
              ),
            ),
          ),
        );
      }
    );
  }
}
