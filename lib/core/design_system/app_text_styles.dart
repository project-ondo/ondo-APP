import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle titleSm({
    required Color? textColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle titleBold16({
    required Color? textColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w700,//Bold
    );
  }

  static TextStyle titleSm14({
    required Color? textColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w600, //smeiBold
    );
  }

  static TextStyle textMedium({
    required Color? textColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle cpation({
    required Color? textColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }
}
