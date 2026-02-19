import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_icon.dart';
import '../../../core/design_system/app_text_styles.dart';

class CustomSettingItem extends StatelessWidget {
  const CustomSettingItem({
    super.key,
    required this.name,
    required this.onTap,
  });

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: AppTextStyles.textMedium(
              textColor: (name == "회원탈퇴") ? AppColors.red : AppColors.gray90,
            ),
          ),
          RotatedBox(
            quarterTurns: 2,
            child: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                AppColors.gray40,
                BlendMode.srcIn,
              ),
              AppIcon.arrowLeft.path,
            ),
          ),
        ],
      ),
    );
  }
}
