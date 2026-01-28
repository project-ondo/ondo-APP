import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/profile_image_setup_controller.dart';

//테스프용 코드 route 작엽 시 삭제 예정
//------------------------------------
void main() {
  Get.put(ProfileImageSetupController());
  runApp(
    MaterialApp(
      home: ProfileImageSetupScreen(),
    ),
  );
}
//------------------------------------

class ProfileImageSetupScreen extends GetView<ProfileImageSetupController> {
  const ProfileImageSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfileSection(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v76,
        Text(
          AppStrings.profileRegistrationTitle,
          style: AppTextStyles.titleSm(),
        ),
        Text(
          AppStrings.stepSkipHint,
          style: AppTextStyles.caption(
            textColor: AppColors.gray70,
          ),
        ),
        AppGap.v40,
        _buildProfileImage(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Align(
      alignment: Alignment.center,
      child: GetBuilder<ProfileImageSetupController>(
        builder: (controller) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              _profileImageView(controller),
              _cameraButtonMenu(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _profileImageView(ProfileImageSetupController controller) {
    return Container(
      width: 180,
      height: 180,
      padding: AppPadding.userCard,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: controller.isDefaultProfile
          ? SvgPicture.asset(AppIcon.defaultProfile.path)
          : ClipOval(
              child: Image.file(
                File(controller.profileImagePath!),
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _cameraButtonMenu(ProfileImageSetupController controller) {
    double popupButtonSize = 135;

    return Container(
      height: 38,
      width: 38,
      margin: EdgeInsets.only(
        bottom: AppSpacing.s18,
        right: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadius.circleRadius,,
        color: AppColors.primary,
      ),
      child: PopupMenuButton<String>(
        color: AppColors.white,
        offset: Offset(-19, 19),
        constraints: BoxConstraints(
          maxWidth: popupButtonSize,
          minWidth: popupButtonSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.baseRadius,
        ),
        padding: EdgeInsets.zero,
        onSelected: (value) {
          if (value == 'gallery') {
            controller.pickFromGallery();
          } else if (value == 'default') {
            controller.resetDefaultProfile();
          }
        },
        itemBuilder: (context) => [
          _popupItem(
            value: 'gallery',
            text: '앨범에서 사진 선택',
          ),
          _popupItem(
            value: 'default',
            text: '기본 프로필 적용',
          ),
        ],
        child: Center(
          child: SvgPicture.asset(AppIcon.camera.path),
        ),
      ),
    );
  }

  PopupMenuItem<String> _popupItem({
    required String value,
    required String text,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 41,
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: AppTextStyles.caption(),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Column(
      children: [
        CustomButton(
          text: '다음',
          variant: ButtonVariant.primary,
          onPressed: controller.submitProfileImage,
        ),
        AppGap.v16,
      ],
    );
  }
}
