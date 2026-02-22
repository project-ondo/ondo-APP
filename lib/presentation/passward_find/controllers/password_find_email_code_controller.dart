import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';

enum PasswordFindEmailCodeState {
  initial,
  invalid,
  valid,
}

class PasswordFindEmailCodeInputController extends GetxController {
  static const String tempEmailCode = '111111';

  late final String passwordFindUserEmail;
  late final TextEditingController passwordFindCodeInputController;

  final Rx<PasswordFindEmailCodeState> passwordFindCodeState = PasswordFindEmailCodeState.initial.obs;

  bool get passwordFindHasCodeInput => passwordFindCodeInputController.text.trim().isNotEmpty;
  bool get passwordFindIsButtonEnabled => passwordFindHasCodeInput;
  bool get passwordFindHasError => passwordFindCodeState.value == PasswordFindEmailCodeState.invalid;
  String get passwordFindErrorMessage => AppStrings.invalidEmailCode;
  String get passwordFindEmail => passwordFindUserEmail;

  @override
  void onInit() {
    super.onInit();
    passwordFindCodeInputController = TextEditingController();
    passwordFindUserEmail = Get.arguments?['email'] ?? '';
    passwordFindCodeInputController.addListener(_onPasswordFindCodeChanged);
  }

  void _onPasswordFindCodeChanged() {
    if (passwordFindCodeState.value == PasswordFindEmailCodeState.invalid) {
      passwordFindCodeState.value = PasswordFindEmailCodeState.initial;
    }
    update();
  }

  void passwordFindVerifyEmailCode() {
    final inputCode = passwordFindCodeInputController.text.trim();

    if (inputCode == tempEmailCode) {
      passwordFindCodeState.value = PasswordFindEmailCodeState.valid;
    } else {
      passwordFindCodeState.value = PasswordFindEmailCodeState.invalid;
    }
    update();
  }

  @override
  void onClose() {
    passwordFindCodeInputController.dispose();
    super.onClose();
  }
}