import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_strings.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var hasError = false.obs;
  var errorMsg = ''.obs;
  var showPassword = false.obs;

  bool validate() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      errorMsg.value = AppStrings.inputEmailandPassword;
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      errorMsg.value = AppStrings.emailRegex;
      return false;
    }

    if (password.length < 8 || password.length > 15) {
      errorMsg.value = AppStrings.passwordLength;
      return false;
    }

    final passwordRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!passwordRegex.hasMatch(password)) {
      errorMsg.value = AppStrings.passwardRegex;
      return false;
    }

    return true;
  }

  void login() {
    hasError.value = false;
    errorMsg.value = '';

    if (!validate()) {
      hasError.value = true;
      return;
    }

    if (emailController.text == 'bulgom@gmail.com' && // 임시 이메일, 비밀번호
        passwordController.text == 'bulgomgom*') {
      debugPrint('로그인 완료');
    } else {
      hasError.value = true;
      errorMsg.value = AppStrings.inputEmailOrPassword;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
