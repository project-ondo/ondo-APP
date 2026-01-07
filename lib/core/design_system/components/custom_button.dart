import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.variant,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: _width,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _borderColor,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.titleSm14(
            textColor: _textColor,
          ),
        ),
      ),
    );
  }

  // ======================
  // Style Resolver
  // ======================

  double get _width {
    switch (variant) {
      case ButtonVariant.primary:
        return 364;
      case ButtonVariant.popup:
        return 356;
      case ButtonVariant.select:
        return 168;
      case ButtonVariant.outline:
        return 168;
    }
  }

  Color get _backgroundColor {
    if (!enabled) return AppColors.gray20;

    switch (variant) {
      case ButtonVariant.outline:
        return Colors.transparent;
      default:
        return AppColors.primary;
    }
  }

  Color get _borderColor {
    if (!enabled) return AppColors.gray40;

    switch (variant) {
      case ButtonVariant.outline:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  Color get _textColor {
    if (!enabled) return AppColors.gray60;

    switch (variant) {
      case ButtonVariant.outline:
        return AppColors.primary;
      default:
        return AppColors.white;
    }
  }
}
