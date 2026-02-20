import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ProfileImageSection extends StatefulWidget {
  const ProfileImageSection({super.key});

  @override
  State<ProfileImageSection> createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        profileImageView(),
        cameraButton(),
      ],
    );
  }

  Widget profileImageView() {
    return Container(
      width: 180,
      height: 180,
      padding: AppPadding.userCard,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: _image != null
          ? ClipOval(
              child: Image.file(
                File(_image!.path),
                fit: BoxFit.cover,
              ),
            )
          : SvgPicture.asset(
              AppIcon.defaultProfile.path,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget cameraButton() {
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
        offset: Offset(-19, 19),
        onSelected: (value) async {
          if (value == 'default') {
            setState(() {
              _image = null;
            });
          } else if (value == 'gallery') {
            await _pickImage();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: AppPadding.settingSession,
            value: "gallery",
            child: Center(
              child: Text(
                "앨범에서 사진 선택",
                style: AppTextStyles.caption(textColor: AppColors.gray90),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          PopupMenuItem(
            padding: AppPadding.settingSession,
            value: "default",
            child: Center(
              child: Text(
                "기본 프로필 적용",
                style: AppTextStyles.caption(textColor: AppColors.gray90),
                textAlign: TextAlign.start,
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
