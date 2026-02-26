import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String comment;
  final VoidCallback actionLeft;
  final VoidCallback actionRight;
  final String leftActionText;
  final String rightActionText;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.comment,
    required this.actionLeft,
    required this.actionRight,
    this.leftActionText = "아니요",
    required this.rightActionText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints.tightFor(width: 380),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.popupRadius),
      insetPadding: AppPadding.basePopup,
      backgroundColor: AppColors.white,
      child: Padding(
        padding: AppPadding.basePopup,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.titleBold20(),
            ),
            AppGap.v24,
            Text(
              comment,
              style: AppTextStyles.textMedium(),
            ),
            AppGap.v24,
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _actions() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(child: CustomButton(text: leftActionText, variant: .outline, hasBorder: true, onPressed: actionLeft,)),
      AppGap.h12,
      Expanded(child: CustomButton(text: rightActionText, variant: .primary, onPressed: actionRight,)),
    ],
  );
}
