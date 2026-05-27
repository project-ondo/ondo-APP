import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/rating_stars.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({
    super.key,
    required this.userName,
    required this.userReview,
    required this.stars,
  });

  final String userName;
  final String userReview;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.card,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //이미지 받음
          SvgPicture.asset(
            AppIcon.defaultProfile.path,
            width: AppSpacing.s36,
            height: AppSpacing.s36,
          ),
          AppGap.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //유저이름 받음
                    Text(
                      userName,
                      style: AppTextStyles.caption(textColor: AppColors.gray60),
                    ),
                    AppGap.h16,
                    //별 개수 받음
                    RatingStars(currentUserStars: stars),
                  ],
                ),
                //리뷰내용 받음
                Text(
                  overflow: TextOverflow.clip,
                  userReview,
                  style: AppTextStyles.caption(textColor: AppColors.gray90),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
