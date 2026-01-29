import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class EmailCodeInputController extends GetxController {
  static const String tempEmailCode = '111111';

  late final String email;

  late final TextEditingController emailCodeTextController;

  final Rx<InputValidationState> codeState = InputValidationState.initial.obs;

  bool get hasCodeInput => emailCodeTextController.text.trim().isNotEmpty;

  bool get isButtonEnabled => hasCodeInput;

  bool get hasError => codeState.value == InputValidationState.invalid;

  String get errorMessage => AppStrings.invalidEmailCode;

  @override
  void onInit() {
    super.onInit();

    emailCodeTextController = TextEditingController();

    email = Get.arguments?['email'] ?? '';

    emailCodeTextController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    if (codeState.value == InputValidationState.invalid) {
      codeState.value = InputValidationState.initial;
    }
    update();
  }

  void verifyEmailCode() {
    final inputCode = emailCodeTextController.text.trim();

    if (inputCode == tempEmailCode) {
      codeState.value = InputValidationState.valid;
    } else {
      codeState.value = InputValidationState.invalid;
    }
    update();
  }

  @override
  void onClose() {
    emailCodeTextController.dispose();
    super.onClose();
  }
}
