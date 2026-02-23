import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/design_system/app_icon.dart';
import '../../../core/design_system/app_layout.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            alignment: Alignment.center,
            width: AppSpacing.s80,
            height: AppSpacing.s80,
            decoration: BoxDecoration(
              borderRadius: AppRadius.circleRadius,
              border: BoxBorder.all(
                width: 2,
                color: Colors.brown,
              ),
            ),
            child: SvgPicture.asset(
              AppIcon.defaultProfile.path,
            ),
          ),

          Positioned(
            right: 12,
            bottom: 4,
            child: SvgPicture.asset(
              AppIcon.star1.path,
              height: 35,
              width: 32,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
