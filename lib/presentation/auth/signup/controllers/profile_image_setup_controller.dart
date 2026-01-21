import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondo/core/design_system/app_icon.dart';

class ProfileImageSetupController extends GetxController{
  late Object profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _setDefaultProfile();
  }

  void _setDefaultProfile() {
    profileImage = SvgPicture.asset(AppIcon.defaultProfile.path);
    update();
  }

  Future<void> pickFromGallery() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      profileImage = image;
      update();
    }
  }

  void applyDefaultProfile(){
    _setDefaultProfile();
  }
  void submitProfileImage(){
    log('프로필 이미지 설정완료: $profileImage');
  }
}