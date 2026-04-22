import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';

class OtherProfileController extends GetxController {
  final UserRemoteDatasource userRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();

  final isLoading = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();
  final profileImageUrl = RxnString();

  Future<void> loadProfile(String publicId) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      profile.value = await userRemoteDatasource.getOtherProfile(publicId);

      // 프로필 이미지 URL 변환
      final imageKey = profile.value?.profileImageKey;
      if (imageKey != null && imageKey.isNotEmpty) {
        profileImageUrl.value = await mediaRemoteDatasource.getDownloadUrl(
          key: imageKey,
        );
      } else {
        profileImageUrl.value = null;
      }
    } catch (e, s) {
      debugPrint('Failed to load other profile: $e\n$s');
      Get.snackbar('오류', '프로필을 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}