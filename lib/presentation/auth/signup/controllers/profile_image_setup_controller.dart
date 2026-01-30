import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageSetupController extends GetxController {
  String? profileImagePath;

  final ImagePicker _picker = ImagePicker();

  bool get isDefaultProfile => profileImagePath == null;

  @override
  void onInit() {
    super.onInit();
    resetDefaultProfile();
  }

  void resetDefaultProfile() {
    profileImagePath = null;
    update();
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImagePath = image.path;
      update();
    }
  }

  void submitProfileImage() {
    log(
      isDefaultProfile
          ? '프로필 이미지 설정완료: 기본 프로필'
          : '프로필 이미지 설정완료: $profileImagePath',
    );
  }
}
