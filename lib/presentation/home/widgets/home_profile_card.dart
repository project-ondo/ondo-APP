import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';

class HomeProfileCard extends StatelessWidget {
  final String name;
  final String skill;
  final int rating;

  const HomeProfileCard({
    super.key,
    required this.skill,
    required this.name,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      padding: AppPadding.card,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.userCardRadius,
      ),
      child: Column(
        children: [
          _profile(),
          AppGap.v8,
          _content(),
          AppGap.v8,
          _stars(),
        ],
      ),
    );
  }

  Widget _profile() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: AppSpacing.s48,
            height: AppSpacing.s48,
            decoration: BoxDecoration(
              borderRadius: AppRadius.circleRadius,
              border: BoxBorder.all(width: 2, color: Colors.brown),
            ),
            child: CustomProfileCircle(radius: AppSpacing.s48),
          ),
        ),

        Positioned(
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            AppIcon.star1.path,
            height: AppSpacing.s36,
            width: AppSpacing.s32,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _content() {
    return Column(
      children: [
        Text(
          name,
          style: AppTextStyles.textMedium(textColor: AppColors.gray90),
        ),
        AppGap.v4,
        Text(
          skill,
          style: AppTextStyles.caption(textColor: AppColors.gray60),
        ),
      ],
    );
  }

  Widget _stars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Image.asset(
          width: AppSpacing.s16,
          height: AppSpacing.s16,
          AppIcon.star.path,
          color: rating > index ? AppColors.primary : AppColors.gray50,
        );
      }),
    );
  }
}
