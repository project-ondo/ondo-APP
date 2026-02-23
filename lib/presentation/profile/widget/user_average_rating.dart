import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/rating_stars.dart';

class UserAverageRating extends StatelessWidget {
  const UserAverageRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "평균평점",
          style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
        ),
        AppGap.h16,
        RatingStars(currentUserStars: 4),
      ],
    );
  }
}
