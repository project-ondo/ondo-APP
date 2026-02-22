import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_chip.dart';

import '../../../core/design_system/app_layout.dart' show AppGap;

class ProfileInterestSection extends StatelessWidget {
  const ProfileInterestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "관심분야",
          style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
        ),
        AppGap.v16,
        Row(
          children: [
            ProfileInterestChip(name: "FrontEnd"),
            AppGap.h10,
            ProfileInterestChip(name: "기획"),
            AppGap.h10,
            ProfileInterestChip(name: "UI/UX"),
          ],
        ),
      ],
    );
  }
}
