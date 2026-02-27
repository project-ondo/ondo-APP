import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/router/bindings/password_reset_binding.dart';
import 'package:ondo/presentation/auth/password_reset/screens/password_reset_email_code_screen.dart';

class PasswordResetController extends GetxController {
  static final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  final emailController = TextEditingController();

  var isEmailValid = false.obs;
  var errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(() {
      final email = emailController.text.trim();
      isEmailValid.value = emailRegex.hasMatch(email);

      errorMsg.value =
      isEmailValid.value || email.isEmpty ? '' : AppStrings.invalidEmailFormat ;
    });
  }

  bool validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      errorMsg.value = '이메일을 입력해주세요.';
      return false;
    }
    if (!isEmailValid.value) {
      errorMsg.value = AppStrings.invalidEmailFormat;
      return false;
    }
    return true;
  }

  void sendVerificationCode() {
    if (validateEmail()) {
      final email = emailController.text.trim();

      debugPrint('인증번호 발송: $email');

      Get.to(
            () => PasswordResetEmailCodeInputScreen(),
        arguments: {'email': email},
        binding: PasswordResetBinding(),
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}