import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final double radius;
  final Widget? prefix;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.radius = 8,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      onChanged: onChanged,
      style: AppTextStyles.textMedium(
        textColor: hasError ? AppColors.red : AppColors.gray80,
      ),
      cursorColor: AppColors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray20,
        hintText: hintText,
        hintStyle: AppTextStyles.textMedium(
          textColor: AppColors.gray60,
        ),
        errorText: errorText,

        // ✅ prefix 유무에 따라 패딩 분기
        contentPadding: prefix == null
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.only(right: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: AppPadding.screenHorizontal,
                child: prefix,
              ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

      ),
    );
  }
}

class LabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;

  const LabelTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

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
        CustomTextField(
          controller: controller,
          hintText: hintText,
          obscureText: obscureText,
          errorText: errorText,
        ),


      ],
    );
  }
}