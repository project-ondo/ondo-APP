import 'dart:developer';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';

class SignupProfileImageSetupController extends GetxController {
  final flowController = Get.find<SignupFlowController>();
  String? profileImagePath;

  final ImagePicker _picker = ImagePicker();

  bool get isDefaultProfile => profileImagePath == null;

  void resetDefaultProfile() {
    profileImagePath = null;
    update();
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        profileImagePath = image.path;
        update();
      }
    } catch(e){
      log("image picker error: $e");
    }
  }

  void submitProfileImage() {
    flowController.setProfileImagePath(profileImagePath);
    log(
      isDefaultProfile
          ? '프로필 이미지 설정완료: 기본 프로필'
          : '프로필 이미지 설정완료: $profileImagePath',
    );
  }
}
