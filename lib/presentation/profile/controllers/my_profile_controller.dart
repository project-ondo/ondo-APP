import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/domain/usecases/auth/logout_usecase.dart';
import 'package:ondo/domain/usecases/user/delete_account_usecase.dart';

class MyProfileController extends GetxController {
  final ProfileRemoteDatasource profileRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();
  final LogoutUseCase logoutUseCase = Get.find();
  final DeleteAccountUseCase deleteAccountUseCase = Get.find();

  final isLoading = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();
  final profileImageUrl = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      profile.value = await profileRemoteDatasource.getMyProfile();

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
      debugPrint('Failed to load my profile: $e\n$s');
      Get.snackbar('오류', '프로필을 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final localDatasource = AuthLocalDatasourceImpl();
      final refreshToken = await localDatasource.getRefreshToken();

      if (refreshToken != null) {
        await logoutUseCase(refreshToken);
      } else {
        await localDatasource.deleteAll();
      }
    } catch (e, s) {
      debugPrint('Failed to logout: $e\n$s');
    }
  }

  Future<bool> deleteAccount() async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      await deleteAccountUseCase();
      final localDatasource = AuthLocalDatasourceImpl();
      await localDatasource.deleteAll();
      return true;
    } catch (e, s) {
      debugPrint('Failed to delete account: $e\n$s');
      Get.snackbar('오류', '회원탈퇴에 실패했습니다.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}