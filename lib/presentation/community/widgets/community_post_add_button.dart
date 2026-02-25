import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';

class CommunityPostAddButton extends StatelessWidget {
  const CommunityPostAddButton.float({super.key})
    : offset = AppPadding.floatingButtonFloatOffset;

  const CommunityPostAddButton.dock({super.key})
    : offset = AppPadding.floatingButtonDockOffset;

  final EdgeInsets offset;

  void createPost() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: offset,
      child: FloatingActionButton(
        onPressed: createPost,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        child: SvgPicture.asset(AppIcon.plus.path),
      ),
    );
  }
}
