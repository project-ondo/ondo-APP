import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class HomeProfileCard extends StatelessWidget {
  final String name;
  final String skill;
  final int getStar;

  const HomeProfileCard({
    super.key,
    required this.skill,
    required this.name,
    required this.getStar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      padding: AppPadding.card,
      decoration: BoxDecoration(color: AppColors.white),
      child: Column( spacing: AppSpacing.s8, children: [
          _profile(),

          _content(),

          _stars(),
        ],
      ),
    );
  }


  final double _profileImageSize = 48;

  Widget _profile() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: _profileImageSize,
            height: _profileImageSize,
            decoration: BoxDecoration(
              borderRadius: AppRadius.circleRadius,
              border: BoxBorder.all(width: 2, color: Colors.brown),
            ),
            child: SvgPicture.asset(AppIcon.defaultProfile.path),
          ),
        ),

        Positioned(
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            AppIcon.star1.path,
            height: 35,
            width: 32,
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
        Text(
          skill,
          style: AppTextStyles.caption(textColor: AppColors.gray60),
        ),
      ],
    );
  }


  final double _starSize = 16;

  Widget _stars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Image.asset(
          width: _starSize,
          height: _starSize,
          AppIcon.star.path,
          color: getStar > index ? AppColors.primary : AppColors.gray50,
        );
      }),
    );
  }
}
