import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';

class SignupProfileImageSetupController extends GetxController {
  final flowController = Get.find<SignupFlowController>();

  String? profileImagePath;
  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  bool get isDefaultProfile => profileImagePath == null;

  void resetDefaultProfile() {
    profileImagePath = null;
    update();
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profileImagePath = image.path;
        update();
      }
    } catch (e) {
      log('image picker error: $e');
    }
  }

  /// 로컬 경로만 flowController에 저장
  /// 실제 업로드는 로그인 후 MediaRemoteDatasource에서 처리
  void submitProfileImage() {
    flowController.setProfileImagePath(profileImagePath);
    flowController.setProfileImageKey(null); // 업로드 전이므로 key는 null

    log(
      isDefaultProfile
          ? '프로필 이미지: 기본 프로필로 진행'
          : '프로필 이미지 로컬 경로 저장: $profileImagePath',
    );
  }
}