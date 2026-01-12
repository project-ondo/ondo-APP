import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

import '../component_variants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? errorText;
  final bool hasError;
  final TextFieldVariant variant;
  final ValueChanged<String>? onChanged;
  final double radius;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.hasError = false,
    this.variant = TextFieldVariant.normal,
    this.onChanged,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          label,
          style: AppTextStyles.textMedium(
            textColor: AppColors.gray80,
          ),
        ),
        const SizedBox(height: 4),

        /// Input
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray20,
            borderRadius: BorderRadius.circular(radius)
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: variant == TextFieldVariant.password,
            onChanged: onChanged,
            style: AppTextStyles.textMedium(
              textColor: hasError ? AppColors.red : AppColors.gray80,
            ),
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: hintText,
              hintStyle: AppTextStyles.textMedium(
                textColor: AppColors.gray60,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),

        /// Error Message
        if (hasError && errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTextStyles.textMedium(
              textColor: AppColors.red,
            ),
          ),
        ],
      ],
    );
  }
}
