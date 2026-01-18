import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool isError;
  final String? errorText;
  final double radius;
  final Widget? prefix;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.isError = false,
    this.errorText,
    this.radius = 8,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = isError || (errorText != null);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: AppTextStyles.textMedium(
        textColor: enabled
            ? (hasError ? AppColors.red : AppColors.gray80)
            : AppColors.gray60,
      ),
      cursorColor: AppColors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray20,
        hintText: hintText,
        hintStyle: AppTextStyles.textMedium(
          textColor: AppColors.gray60,
        ),

        // prefix 유무에 따른 패딩 분기
        contentPadding: prefix == null
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
            : const EdgeInsets.only(right: 16, top: 14, bottom: 14),

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
        disabledBorder: OutlineInputBorder(
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

/// ---------------------------------------------------------------------------
/// LabelTextField
/// - 화면용 조합 컴포넌트
/// - Label + Input + Error
/// - prefix ❌
/// ---------------------------------------------------------------------------
class LabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool isError;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const LabelTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.isError = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
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
        AppGap.v4,

        /// Input
        CustomTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          isError: isError,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          errorText: errorText,
        ),

        /// Error Message
        if (errorText != null) ...[
          AppGap.v8,
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
