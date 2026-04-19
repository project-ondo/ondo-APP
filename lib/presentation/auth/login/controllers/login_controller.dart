import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/domain/usecases/auth/sign_in_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final SignInUseCase signInUseCase;
  final MediaRemoteDatasource mediaRemoteDatasource;
  final ProfileRemoteDatasource profileRemoteDatasource;

  LoginController({
    required this.signInUseCase,
    required this.mediaRemoteDatasource,
    required this.profileRemoteDatasource,
  });

  static const String _profileImagePathKey = 'pending_profile_image_path';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var emailError = RxnString();
  var passwordError = RxnString();
  var generalError = RxnString();
  var showPassword = false.obs;
  var isLoading = false.obs;

  bool validate() {
    emailError.value = null;
    passwordError.value = null;
    generalError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      emailError.value = AppStrings.inputEmailAndPassword;
      passwordError.value = AppStrings.inputEmailAndPassword;
      return false;
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = AppStrings.emailRegex;
      return false;
    }

    if (password.length < 8 || password.length > 50) {
      passwordError.value = AppStrings.passwordLength;
      return false;
    }

    return true;
  }

  Future<bool> login() async {
    if (!validate()) return false;
    if (isLoading.value) return false;

    try {
      isLoading.value = true;

      // loginId = 이메일 @ 앞부분 (회원가입 시 동일하게 처리)
      final loginId = emailController.text.trim().split('@').first;

      final success = await signInUseCase(
        loginId: loginId,
        password: passwordController.text,
      );

      if (!success) {
        generalError.value = AppStrings.inputEmailOrPassword;
        return false;
      }

      generalError.value = null;

      // 로그인 성공 후 대기 중인 프로필 이미지 업로드 처리
      await _uploadPendingProfileImage();

      return true;
    } catch (e) {
      generalError.value = AppStrings.inputEmailOrPassword;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// SharedPreferences에 저장된 프로필 이미지 경로 확인 후 업로드 및 프로필 반영
  Future<void> _uploadPendingProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString(_profileImagePathKey);

      if (imagePath == null || imagePath.isEmpty) return;

      debugPrint('[프로필 이미지 업로드 시작] path: $imagePath');

      // 1단계: S3 업로드 → key 반환
      final imageKey = await mediaRemoteDatasource.uploadImage(
        imagePath: imagePath,
      );

      debugPrint('[프로필 이미지 S3 업로드 완료] key: $imageKey');

      // 2단계: PUT /users/my/profile/image 로 key 반영
      await profileRemoteDatasource.updateProfileImage(imageKey);

      debugPrint('[프로필 이미지 반영 완료]');

      // 업로드 완료 후 임시 데이터 삭제
      await prefs.remove(_profileImagePathKey);
    } catch (e, s) {
      // 이미지 업로드 실패해도 로그인은 성공으로 처리
      debugPrint('프로필 이미지 업로드 실패 (무시): $e\n$s');
    }
  }

  /// 회원가입 완료 후 이미지 경로를 SharedPreferences에 임시 저장
  static Future<void> savePendingProfileImage(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (imagePath != null && imagePath.isNotEmpty) {
      await prefs.setString(_profileImagePathKey, imagePath);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}