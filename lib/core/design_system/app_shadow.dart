import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';

class AppShadow {
  static const barShadow = BoxShadow(
    color: AppColors.shadowGray,
    offset: Offset(0, -16),
    blurRadius: 16.0,
    spreadRadius: 0.0,
  );
}
