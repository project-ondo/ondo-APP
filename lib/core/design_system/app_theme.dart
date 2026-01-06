import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData appTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.primary,
      focusColor: AppColors.balck,
    );
  }
}
