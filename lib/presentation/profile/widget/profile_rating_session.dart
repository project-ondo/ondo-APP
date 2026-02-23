import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/presentation/profile/widget/current_review_session.dart';
import 'package:ondo/presentation/profile/widget/review_chips.dart';
import 'package:ondo/presentation/profile/widget/user_average_rating.dart';

class ProfileRatingSession extends StatelessWidget {
  const ProfileRatingSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAverageRating(),
          AppGap.v16,
          ReviewChips(),
          CurrentReviewSession(),
        ],
      ),
    );
  }
}
