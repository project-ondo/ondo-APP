import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/domain/usecases/auth/logout_usecase.dart';

class MyProfileController extends GetxController {
  final ProfileRemoteDatasource profileRemoteDatasource = Get.find();
  final LogoutUseCase logoutUseCase = Get.find();

  final isLoading = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();

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
    } catch (e, s) {
      debugPrint('Failed to load my profile: $e\n$s');
      Get.snackbar('오류', '프로필을 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  /// refreshToken 분기 로직은 LogoutUseCase에서 처리
  /// 네비게이션은 Screen에서 처리 (context.go)
  Future<void> logout(BuildContext context) async {
    try {
      await logoutUseCase();
    } catch (e, s) {
      debugPrint('Failed to logout: $e\n$s');
    }
  }

  Future<bool> deleteAccount() async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      await profileRemoteDatasource.deleteAccount();
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