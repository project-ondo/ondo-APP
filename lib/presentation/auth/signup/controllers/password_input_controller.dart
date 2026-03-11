import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/password_policy.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class PasswordInputController extends GetxController {
  final flowController = Get.find<SignupFlowController>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isObscure = true.obs;
  final state = InputValidationState.initial.obs;
  final passwordResult = PasswordValidationResult.valid.obs;

  /// 버튼 클릭 여부
  bool _submitted = false;

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
  }

  void toggleObscure() => isObscure.toggle();

  void _onTextChanged() {
    _validate();
  }

  /// 버튼 클릭 시 호출
  void submit() {
    _submitted = true;
    _validate();
  }

  void _validate() {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    passwordResult.value = PasswordPolicy.validate(password);

    if (password.isEmpty || confirm.isEmpty) {
      state.value = InputValidationState.invalid;
      return;
    }

    if (passwordResult.value != PasswordValidationResult.valid) {
      state.value = InputValidationState.invalid;
      return;
    }

    if (password != confirm) {
      state.value = InputValidationState.mismatch;
      return;
    }

    state.value = InputValidationState.valid;
  }

  bool get canProceed => state.value == InputValidationState.valid;

  String? get passwordErrorText {
    if (!_submitted) return null;

    if (passwordResult.value == PasswordValidationResult.valid) {
      return null;
    }

    return AppStrings.passwordError(passwordResult.value);
  }

  String? get confirmPasswordErrorText {
    if (!_submitted) return null;

    if (state.value == InputValidationState.mismatch) {
      return AppStrings.invalidPassword;
    }
    return null;
  }

  void savePassword() {
    flowController.setPassword(passwordController.text);
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
