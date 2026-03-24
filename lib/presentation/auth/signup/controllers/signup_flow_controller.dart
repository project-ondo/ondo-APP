import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/domain/usecases/auth/signup_usecase.dart';

class SignupFlowController extends GetxController {
  final SignupUsecase signupUsecase = Get.find();

  String? email;
  String? loginId;
  bool isEmailVerified = false;
  String? verificationToken;
  String? password;
  String? nickname;
  String? introduction;
  String? profileImagePath;
  String? profileImageKey;
  String? major;
  String gender = 'MALE';

  final isLoading = false.obs;

  Set<String> interests = {};

  bool get isValid {
    return email != null &&
        isEmailVerified &&
        verificationToken != null &&
        password != null &&
        nickname != null &&
        major != null &&
        interests.isNotEmpty;
  }

  void setNickname(String value) {
    nickname = value;
  }

  void setLoginId(String value){
    loginId = value;
  }

  void setEmail(String value) {
    email = value;

    final id = value.split('@').first;
    setLoginId(id);
  }

  void setEmailVerified(bool value) {
    isEmailVerified = value;
  }

  void setVerificationToken(String value) {
    verificationToken = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setIntroduction(String value) {
    introduction = value;
  }

  void setMajor(String value) {
    major = value;
  }

  void setProfileImagePath(String? value) {
    profileImagePath = value;
  }

  void setProfileImageKey(String? value) {
    profileImageKey = value;
  }

  void setInterests(Set<String> value) {
    interests = value;
  }

  void setGender(String value) {
    gender = value;
  }

  Future<bool> submitInfo() async {
    if (!isValid) return false;
    if (isLoading.value) return false;

    try {
      isLoading.value = true;

      // 디버그용 로그 추가
      debugPrint('=== 회원가입 요청 데이터 ===');
      debugPrint('email: $email');
      debugPrint('loginId: $loginId');
      debugPrint('verificationToken: $verificationToken');
      debugPrint('password: $password');
      debugPrint('nickname: $nickname');
      debugPrint('gender: $gender');
      debugPrint('major: $major');
      debugPrint('interests: $interests');
      debugPrint('profileImageKey: $profileImageKey');

      final model = SignupRequestModel(
        verificationToken: verificationToken!,
        loginId: loginId!,
        password: password!,
        displayName: nickname!,
        gender: gender,
        major: major!,
        interests: interests.toList(),
        profileImageKey: profileImageKey,
      );
      await signupUsecase(model);
      return true;
    } catch (e, s) {
      debugPrint('Failed to signup: $e\n$s');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    email = null;
    loginId = null;
    isEmailVerified = false;
    verificationToken = null;
    password = null;
    nickname = null;
    introduction = null;
    major = null;
    interests.clear();
    profileImagePath = null;
    profileImageKey = null;
    gender = 'MALE';
  }
}
