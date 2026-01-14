import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EmailInputState {
  initial,
  invalid,
  valid,
}

class EmailController extends GetxController {
  late final TextEditingController emailTextController;

  EmailInputState emailState = EmailInputState.initial;

  bool get hasEmailInput => emailTextController.text.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    emailTextController = TextEditingController();

    // 텍스트 변경 시 자동으로 UI 업데이트
    emailTextController.addListener(() {
      update();
    });
  }

  @override
  void onClose() {
    emailTextController.dispose();
    super.onClose();
  }

  bool validateEmail(String email) {
    if (_isValidEmail(email)) {
      emailState = EmailInputState.valid;
      update();
      return true;
    } else {
      emailState = EmailInputState.invalid;
      update();
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void resetState() {
    if (emailState == EmailInputState.invalid) {
      emailState = EmailInputState.initial;
      update();
    }
  }
}