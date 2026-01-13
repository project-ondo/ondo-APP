import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_icon.dart';

class LoginBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const LoginBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(AppIcon.arrowLeft.path),
          Text(
            '로그인으로',
            style: TextStyle(
              color: AppColors.gray60,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
