import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_chip.dart';

class ProfileInterestSection extends StatelessWidget {
  const ProfileInterestSection({super.key, required this.interests});

  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '관심분야',
          style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
        ),
        AppGap.v16,
        Wrap(
          spacing: AppSpacing.s10,
          runSpacing: AppSpacing.s8,
          children: interests
              .map((e) => ProfileInterestChip(name: e))
              .toList(),
        ),
      ],
    );
  }
}