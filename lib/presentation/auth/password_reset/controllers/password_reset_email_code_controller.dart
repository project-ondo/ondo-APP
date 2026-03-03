import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';

enum PasswordResetEmailCodeState {
  initial,
  invalid,
  valid,
}

class PasswordResetEmailCodeController extends GetxController {
  final flowController = Get.find<PasswordResetFlowController>();
  static const String tempEmailCode = '111111';

  late final TextEditingController passwordResetCodeInputController;

  final Rx<PasswordResetEmailCodeState> passwordResetCodeState = PasswordResetEmailCodeState.initial.obs;

  bool get passwordResetHasCodeInput => passwordResetCodeInputController.text.trim().isNotEmpty;
  bool get passwordResetIsButtonEnabled => passwordResetHasCodeInput;
  bool get passwordResetHasError => passwordResetCodeState.value == PasswordResetEmailCodeState.invalid;
  String get passwordResetErrorMessage => AppStrings.invalidEmailCode;
  String get passwordResetEmail => flowController.email;

  @override
  void onInit() {
    super.onInit();
    passwordResetCodeInputController = TextEditingController();
    passwordResetCodeInputController.addListener(_onPasswordResetCodeChanged);
  }

  void _onPasswordResetCodeChanged() {
    if (passwordResetCodeState.value == PasswordResetEmailCodeState.invalid) {
      passwordResetCodeState.value = PasswordResetEmailCodeState.initial;
    }
  }

  void passwordResetVerifyEmailCode() {
    final inputCode = passwordResetCodeInputController.text.trim();

    if (inputCode == tempEmailCode) {
      passwordResetCodeState.value = PasswordResetEmailCodeState.valid;
      flowController.setVerificationCode(true);
    } else {
      passwordResetCodeState.value = PasswordResetEmailCodeState.invalid;
    }
  }

  @override
  void onClose() {
    passwordResetCodeInputController.dispose();
    super.onClose();
  }
}