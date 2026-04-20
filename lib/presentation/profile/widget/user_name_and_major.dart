import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class UserNameAndMajor extends StatelessWidget {
  const UserNameAndMajor({
    super.key,
    required this.name,
    required this.major,
  });

  final String name;
  final String major;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTextStyles.profileIntroduction(textColor: AppColors.gray90),
        ),
        Text(
          major,
          style: AppTextStyles.profileIntroduction(textColor: AppColors.gray60),
        ),
      ],
    );
  }
}