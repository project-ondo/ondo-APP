import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  var isEmailValid = false.obs;

  var errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(() {
      final email = emailController.text.trim();
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
