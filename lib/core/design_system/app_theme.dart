import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData appTheme() {
    return ThemeData(
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.primary,
      focusColor: AppColors.black,
    );
  }
}

