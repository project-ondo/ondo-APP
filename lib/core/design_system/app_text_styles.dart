import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle titleSm({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle titleBold16({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700, //Bold
    );
  }

  static TextStyle titleSm14({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600, //smeiBold
    );
  }

  static TextStyle titleSm16({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600, //smeiBold
    );
  }

  static TextStyle textMedium({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle pageIndicator({
    bool isCurrent = false,
  }) {
    return TextStyle(
      color: isCurrent ? AppColors.primary : AppColors.gray45,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      decoration: isCurrent ? TextDecoration.underline : null,
      decorationColor: AppColors.primary,
    );
  }

  static TextStyle caption({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle subCaption({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle captionSmall({
    Color? textColor,
  }) {
    return TextStyle(
      color: textColor ?? AppColors.black,
      fontSize: 8,
      fontWeight: FontWeight.w600,
    );
  }



}
