import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class UserIntroductionText extends StatelessWidget {
  const UserIntroductionText({super.key, this.bio});

  final String? bio;

  @override
  Widget build(BuildContext context) {
    if (bio == null || bio!.isEmpty) return const SizedBox.shrink();

    return Text(
      bio!,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      style: AppTextStyles.profileIntroduction(textColor: AppColors.gray90),
    );
  }
}