import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';

class CustomConfirmPopup extends StatelessWidget {
  const CustomConfirmPopup({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: AppColors.white,
      insetPadding: AppPadding.screenHorizontal,
      child: Container(
        padding: AppPadding.actionPopup,
        decoration: BoxDecoration(
          borderRadius: AppRadius.popupRadius,
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(title, style: AppTextStyles.titleBold20())),
            AppGap.v24,
            Center(
              child: Text(
                description,
                style: AppTextStyles.textMedium(),
              ),
            ),
            AppGap.v24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                    text: confirmText,
                    variant: ButtonVariant.outline,
                    hasBorder: true,
                    onPressed: onConfirm,
                  ),
                ),
                AppGap.h12,
                Expanded(
                  child: CustomButton(
                    text: cancelText,
                    variant: ButtonVariant.select,
                    onPressed: onCancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
