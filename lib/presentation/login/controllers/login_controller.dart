import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
      errorMsg.value = '이메일과 비밀번호를 입력해주세요.';
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      errorMsg.value = '이메일 형식이 올바르지 않아요.';
      return false;
    }

    if (password.length < 8 || password.length > 15) {
      errorMsg.value = '비밀번호는 8~15자여야 해요.';
      return false;
    }

    final passwordRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!passwordRegex.hasMatch(password)) {
      errorMsg.value = '비밀번호에 특수기호를 포함해주세요.';
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
      print('로그인 완료');
    } else {
      hasError.value = true;
      errorMsg.value = '이메일 또는 비밀번호가 일치하지 않아요.';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
