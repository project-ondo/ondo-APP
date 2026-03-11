import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class EmailCodeInputController extends GetxController {
  final flowController = Get.find<SignupFlowController>();

  static const String tempEmailCode = '111111';

  late final TextEditingController emailCodeTextController;

  final code = ''.obs;

  final Rx<InputValidationState> codeState = InputValidationState.initial.obs;

  String get email => flowController.email ?? "";

  bool get isButtonEnabled => code.value.trim().isNotEmpty;

  bool get hasError => codeState.value == InputValidationState.invalid;

  String get errorMessage => AppStrings.invalidEmailCode;

  @override
  void onInit() {
    super.onInit();
    emailCodeTextController = TextEditingController();

    emailCodeTextController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    code.value = emailCodeTextController.text;

    if (codeState.value == InputValidationState.invalid) {
      codeState.value = InputValidationState.initial;
    }
  }

  bool verifyEmailCode() {
    final inputCode = emailCodeTextController.text.trim();

    if (inputCode == tempEmailCode) {
      codeState.value = InputValidationState.valid;

      flowController.setEmailVerified(true);
      return true;
    } else {
      codeState.value = InputValidationState.invalid;

      return false;
    }
  }

  @override
  void onClose() {
    emailCodeTextController.dispose();
    super.onClose();
  }
}
