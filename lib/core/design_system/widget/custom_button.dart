import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CustomButton {
  static GestureDetector customButton({
    required String buttonName,
    required Color? buttonColor,
    GestureTapCallback? onPressed,
    required Color? textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 364,
        height: 52,
        child: Center(
          child: Text(
            buttonName,
            style: AppTextStyles.titleSm14(textColor: textColor),
          ),
        ),
      ),
    );
  }

  static GestureDetector customPopupButton({
    required GestureTapCallback? onPressed,
    required Color? buttonColor,
    required String buttonName,
    required Color? textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 356,
        height: 52,
        child: Center(
          child: Text(
            buttonName,
            style: AppTextStyles.titleSm14(textColor: textColor),
          ),
        ),
      ),
    );
  }

  static GestureDetector customSelectButton({
    required GestureTapCallback? onPressed,
    required Color? buttonColor,
    required String buttonName,
    required Color? textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 168,
        height: 52,
        child: Center(
          child: Text(
            buttonName,
            style: AppTextStyles.titleSm14(textColor: textColor),
          ),
        ),
      ),
    );
  }
}
