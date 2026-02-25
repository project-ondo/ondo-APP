import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CommunityCustomIconButton extends StatelessWidget {
  CommunityCustomIconButton({
    super.key,
    required this.imagePath,
    required int total,
    bool? initialSelect,
    required this.activeColor,
    required this.action,
  }) {
    this.total = ValueNotifier(total);
    isSelected = ValueNotifier(initialSelect ?? false);
  }

  final String imagePath;
  late final ValueNotifier<int> total;
  late final ValueNotifier<bool> isSelected;
  final Color activeColor;
  final void Function(bool isSelect, int total) action;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([isSelected, total]),
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                isSelected.value = !isSelected.value;
                isSelected.value ? total.value += 1 : total.value -= 1;
                action.call(isSelected.value, total.value);
              },
              child: Image.asset(
                imagePath,
                color: isSelected.value ? activeColor : AppColors.gray50,
                height: AppSpacing.s32,
                width: AppSpacing.s32,
              ),
            ),
            AppGap.h4,
            Text(
              "${total.value}",
              style: AppTextStyles.textMedium(textColor: AppColors.gray50),
            ),
          ],
        );
      },
    );
  }
}
