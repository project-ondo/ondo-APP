import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';

enum PasswordResetEmailCodeState {
  initial,
  invalid,
  valid,
}

class PasswordResetEmailCodeController extends GetxController {
  static const String tempEmailCode = '111111';

  late final String passwordResetUserEmail;
  late final TextEditingController passwordResetCodeInputController;

  final Rx<PasswordResetEmailCodeState> passwordResetCodeState = PasswordResetEmailCodeState.initial.obs;

  bool get passwordResetHasCodeInput => passwordResetCodeInputController.text.trim().isNotEmpty;
  bool get passwordResetIsButtonEnabled => passwordResetHasCodeInput;
  bool get passwordResetHasError => passwordResetCodeState.value == PasswordResetEmailCodeState.invalid;
  String get passwordResetErrorMessage => AppStrings.invalidEmailCode;
  String get passwordResetEmail => passwordResetUserEmail;

  @override
  void onInit() {
    super.onInit();
    passwordResetCodeInputController = TextEditingController();
    passwordResetUserEmail = Get.arguments?['email'] ?? '';
    passwordResetCodeInputController.addListener(_onPasswordResetCodeChanged);
  }

  void _onPasswordResetCodeChanged() {
    if (passwordResetCodeState.value == PasswordResetEmailCodeState.invalid) {
      passwordResetCodeState.value = PasswordResetEmailCodeState.initial;
    }
    update();
  }

  void passwordResetVerifyEmailCode() {
    final inputCode = passwordResetCodeInputController.text.trim();

    if (inputCode == tempEmailCode) {
      passwordResetCodeState.value = PasswordResetEmailCodeState.valid;
    } else {
      passwordResetCodeState.value = PasswordResetEmailCodeState.invalid;
    }
    update();
  }

  @override
  void onClose() {
    passwordResetCodeInputController.dispose();
    super.onClose();
  }
}