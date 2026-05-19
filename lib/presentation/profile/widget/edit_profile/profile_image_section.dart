import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    this.imagePath,
    this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final String? imagePath;   // 로컬에서 선택한 이미지 경로
  final String? imageUrl;    // 서버 이미지 URL
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _profileImageView(),
        _cameraButton(context),
      ],
    );
  }

  Widget _profileImageView() {
    return Container(
      width: 180,
      height: 180,
      padding: AppPadding.userCard,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: imagePath != null
            ? Image.file(File(imagePath!), fit: BoxFit.cover)
            : imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : SvgPicture.asset(
          AppIcon.defaultProfile.path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _cameraButton(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      margin: AppPadding.camera,
      decoration: BoxDecoration(
        borderRadius: AppRadius.circleRadius,
        color: AppColors.primary,
      ),
      child: PopupMenuButton<String>(
        color: AppColors.white,
        offset: const Offset(-19, 19),
        onSelected: (value) {
          if (value == 'default') {
            onRemoveImage();
          } else if (value == 'gallery') {
            onPickImage();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: AppPadding.settingSession,
            value: 'gallery',
            child: Center(
              child: Text(
                '앨범에서 사진 선택',
                style: AppTextStyles.caption(textColor: AppColors.gray90),
              ),
            ),
          ),
          PopupMenuItem(
            padding: AppPadding.settingSession,
            value: 'default',
            child: Center(
              child: Text(
                '기본 프로필 적용',
                style: AppTextStyles.caption(textColor: AppColors.gray90),
              ),
            ),
          ),
        ],
        child: Center(
          child: SvgPicture.asset(AppIcon.camera.path),
        ),
      ),
    );
  }
}