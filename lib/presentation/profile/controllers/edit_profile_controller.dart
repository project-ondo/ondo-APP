import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/models/user/request/update_profile_request_model.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileRemoteDatasource profileRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();

  final isLoading = false.obs;
  final Rxn<XFile> selectedImage = Rxn();
  final profileImageUrl = RxnString();

  final displayName = ''.obs;
  final bio = ''.obs;
  final selectedMajor = ''.obs;
  final selectedInterests = <String>{}.obs;

  final List<String> tags = [
    'FrontEnd', 'BackEnd', 'AI', 'devops',
    '기획', 'UI/UX', 'Android', 'ios', 'Cloud',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final myProfileController = Get.find<MyProfileController>();
    final profile = myProfileController.profile.value;

    if (profile != null) {
      displayName.value = profile.displayName;
      bio.value = profile.bio ?? '';
      selectedMajor.value = profile.major;
      selectedInterests.assignAll(profile.interests);
    }

    // 기존 프로필 이미지 URL 가져오기
    profileImageUrl.value = myProfileController.profileImageUrl.value;
  }

  void toggleInterest(String tag) {
    if (selectedInterests.contains(tag)) {
      selectedInterests.remove(tag);
    } else {
      selectedInterests.add(tag);
    }
  }

  void selectMajor(String tag) {
    selectedMajor.value = tag;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      selectedImage.value = picked;
      profileImageUrl.value = null; // 새 이미지 선택 시 기존 URL 초기화
    }
  }

  void removeImage() {
    selectedImage.value = null;
    profileImageUrl.value = null;
  }

  Future<bool> saveProfile({
    required String displayName,
    required String bio,
  }) async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;

      // 1. 프로필 이미지 변경 (새로 선택된 경우)
      if (selectedImage.value != null) {
        final imageKey = await mediaRemoteDatasource.uploadImage(
          imagePath: selectedImage.value!.path,
        );
        await profileRemoteDatasource.updateProfileImage(imageKey);
      }

      // 2. 프로필 정보 수정
      await profileRemoteDatasource.updateProfile(
        UpdateProfileRequestModel(
          displayName: displayName,
          gender: null,
          major: selectedMajor.value.isNotEmpty ? selectedMajor.value : null,
          interests: selectedInterests.toList(),
          bio: bio,
        ),
      );

      // 3. MyProfileController 프로필 갱신
      await Get.find<MyProfileController>().loadProfile();

      Get.snackbar('완료', '프로필이 수정되었습니다.');
      return true;
    } catch (e, s) {
      debugPrint('Failed to save profile: $e\n$s');
      Get.snackbar('오류', '프로필 수정에 실패했습니다.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}