import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class TitleText {
  static Text titleText(String text) {
    return Text(
      text,
      style: AppTextStyles.titleSm(),
    );
  }
}
