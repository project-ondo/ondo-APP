import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.currentUserStars,
  });

  final int currentUserStars;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Image.asset(
          width: AppSpacing.s16,
          height: AppSpacing.s16,
          AppIcon.star.path,
          color: currentUserStars > index
              ? AppColors.primary
              : AppColors.gray50,
        );
      }),
    );
  }
}
