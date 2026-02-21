import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class AlertDeleteDialog extends StatelessWidget {
  final VoidCallback close;
  final VoidCallback delete;

  const AlertDeleteDialog({
    super.key,
    required this.close,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.popupRadius),
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.white,
      child: Padding(
        padding: AppPadding.basePopup,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "알림",
              style: AppTextStyles.popupTitle(),
            ),
            AppGap.v24,
            Text(
              "정말 모든 알림을 삭제하시겠어요?",
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
    mainAxisSize: MainAxisSize.min,
    children: [
      _customButton(
        text: "아니요",
        action: close,
        textColor: AppColors.primary,
        isFill: false,
      ),
      AppGap.h16,
      _customButton(text: "삭제", action: delete, textColor: AppColors.white),
    ],
  );

  Widget _customButton({
    required String text,
    required VoidCallback action,
    required Color textColor,
    Color color = AppColors.primary,
    bool isFill = true,
  }) => TextButton(
    onPressed: action,
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.baseRadius,
        side: !isFill ? BorderSide(color: color, width: 1) : BorderSide.none,
      ),
      backgroundColor: isFill ? color : AppColors.white,
      minimumSize: Size(168, double.minPositive),
      padding: AppPadding.dialogButton,
    ),
    child: Text(
      text,
      style: AppTextStyles.titleSm14(textColor: textColor),
    ),
  );
}
