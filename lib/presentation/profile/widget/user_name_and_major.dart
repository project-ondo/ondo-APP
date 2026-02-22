import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_text_styles.dart';

class UserNameAndMajor extends StatelessWidget {
  const UserNameAndMajor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "김유찬",
          style: AppTextStyles.profileIntroduction(
            textColor: AppColors.gray90,
          ),
        ),
        Text(
          "UI/UX",
          style: AppTextStyles.profileIntroduction(
            textColor: AppColors.gray60,
          ),
        ),
      ],
    );
  }
}
