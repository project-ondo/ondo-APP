import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool enabled;
  final bool hasBorder;

  const CustomButton({
    super.key,
    required this.text,
    required this.variant,
    this.size = ButtonSize.medium,
    this.onPressed,
    this.enabled = true,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onPressed : null,
        child: Container(
          padding: _effectivePadding, // 수정: padding 보정 적용
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: hasBorder
                ? Border.all(
              color: _borderColor,
              width: 1,
            )
                : null, // 수정: hasBorder false이면 border 없음
          ),
          child: Text(
            text,
            style: AppTextStyles.titleSm14(
              textColor: _textColor,
            ),
          ),
        ),
      ),
    );
  }

  // ======================
  // Size Resolver
  // ======================
  EdgeInsets get _paddingBySize {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  // ======================
  // Style Resolver
  // ======================
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

  EdgeInsetsGeometry get _effectivePadding {
    // border가 있을 때만 padding을 1px 빼서 안쪽 border 느낌 구현
    if (hasBorder) {
      return _paddingBySize.subtract(const EdgeInsets.all(1));
    }
    return _paddingBySize;
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
