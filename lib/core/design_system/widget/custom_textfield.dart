import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CustomTextField {
  static Container customTextField({
    required String? labelText,
    required String? hintText,
    required TextInputType? keyboardType,
    required String? errorText,
    required bool hasError,
    bool? isPassword,
  }) {
    return Container(
      alignment: Alignment.topCenter,
      height: 93 + 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text(
              labelText!,
              style: AppTextStyles.textMedium(
                textColor: AppColors.gray80,
              ),
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: isPassword ?? false,
            style: AppTextStyles.textMedium(
              textColor: hasError ? AppColors.red : AppColors.gray80,
            ),
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              hintText: hintText,
              hintStyle: AppTextStyles.textMedium(
                textColor: AppColors.gray60,
              ),
              filled: true,
              fillColor: AppColors.gray20,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 8),
          if (hasError)
            Text(
              errorText!,
              style: AppTextStyles.textMedium(
                textColor: AppColors.red,
              ),
            ),
        ],
      ),
    );
  }
}
