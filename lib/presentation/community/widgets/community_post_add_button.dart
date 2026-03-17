import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityPostAddButton extends GetView<CommunityController> {
  const CommunityPostAddButton.float({super.key})
    : offset = AppPadding.floatingButtonFloatOffset;

  const CommunityPostAddButton.dock({super.key})
    : offset = AppPadding.floatingButtonDockOffset;

  final EdgeInsets offset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: offset,
      child: FloatingActionButton(
        onPressed: controller.enterPostCreate,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        child: SvgPicture.asset(AppIcon.plus.path),
      ),
    );
  }
}
