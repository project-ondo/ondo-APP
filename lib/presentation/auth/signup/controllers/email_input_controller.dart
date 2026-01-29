import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class EmailInputController extends GetxController {
  late final TextEditingController emailTextController;

  InputValidationState emailState = InputValidationState.initial;

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
      emailState = InputValidationState.valid;
      update();
      return true;
    } else {
      emailState = InputValidationState.invalid;
      update();
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void resetState() {
    if (emailState == InputValidationState.invalid) {
      emailState = InputValidationState.initial;
      update();
    }
  }
}