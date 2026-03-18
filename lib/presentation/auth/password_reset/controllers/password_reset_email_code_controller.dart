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

  final code = ''.obs;

  final Rx<PasswordResetEmailCodeState> passwordResetCodeState = PasswordResetEmailCodeState.initial.obs;

  bool get passwordResetIsButtonEnabled => code.value.trim().isNotEmpty;
  bool get passwordResetHasError => passwordResetCodeState.value == PasswordResetEmailCodeState.invalid;
  String get passwordResetErrorMessage => AppStrings.invalidEmailCode;
  String get passwordResetEmail => flowController.email;

  @override
  void onInit() {
    super.onInit();
    passwordResetCodeInputController = TextEditingController();
    passwordResetCodeInputController.addListener(() {
      code.value = passwordResetCodeInputController.text;

      if(passwordResetCodeState.value == PasswordResetEmailCodeState.invalid){
        passwordResetCodeState.value = PasswordResetEmailCodeState.initial;
      }
    });
  }

  bool passwordResetVerifyEmailCode() {
    final inputCode = code.value.trim();

    if (inputCode == tempEmailCode) {
      passwordResetCodeState.value = PasswordResetEmailCodeState.valid;
      flowController.setVerificationCode(true);
      return true;
    } else {
      passwordResetCodeState.value = PasswordResetEmailCodeState.invalid;
      return false;
    }
  }

  @override
  void onClose() {
    passwordResetCodeInputController.dispose();
    super.onClose();
  }
}