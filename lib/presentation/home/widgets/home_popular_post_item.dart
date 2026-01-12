import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

@immutable
class HomePopularPostItem extends StatelessWidget {
  final int rank;
  final String title;
  final int createAgo;
  final int favorite;

  const HomePopularPostItem({
    super.key,
    required this.title,
    required this.createAgo,
    required this.favorite,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 42,
            height: double.maxFinite,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "$rank",
                style: AppTextStyles.textMedium(textColor: AppColors.primary),
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.textMedium(textColor: AppColors.gray90),
                ),

                Text(
                  "$createAgo일 전",
                  style: AppTextStyles.subCaption(textColor: AppColors.gray60),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Row(
            children: [
              Image.asset(
                AppIcon.heart.path,
                color: AppColors.gray40,
                width: 16,
                height: 16,
              ),
              Text(
                "$favorite",
                style: AppTextStyles.caption(textColor: AppColors.gray40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
