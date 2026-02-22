import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/passward_find/screens/password_find_email_code_screen.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  var isEmailValid = false.obs;
  var errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(() {
      final email = emailController.text.trim();
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      isEmailValid.value = emailRegex.hasMatch(email);

      errorMsg.value =
      isEmailValid.value || email.isEmpty ? '' : '올바른 이메일 형식이 아닙니다.';
    });
  }

  bool validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      errorMsg.value = '이메일을 입력해주세요.';
      return false;
    }
    if (!isEmailValid.value) {
      errorMsg.value = '올바른 이메일 형식이 아닙니다.';
      return false;
    }
    return true;
  }

  /// 인증번호 발송 및 다음 화면으로 이동
  void sendVerificationCode() {
    if (validateEmail()) {
      final email = emailController.text.trim();

      debugPrint('인증번호 발송: $email');

      Get.to(
            () => PasswordFindEmailCodeInputScreen(),
        arguments: {'email': email},
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}