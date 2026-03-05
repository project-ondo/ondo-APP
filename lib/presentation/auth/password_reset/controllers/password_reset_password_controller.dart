import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/password_policy.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class PasswordResetPasswordController extends GetxController {
  final flowController = Get.find<PasswordResetFlowController>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isObscure = true.obs;
  final Rx<InputValidationState> state = InputValidationState.initial.obs;

  final RxBool hasInput = false.obs;

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
    hasInput.value =
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

      _validate();
  }

  /// 버튼 클릭 시 호출
  void submit() {
    _submitted = true;
    _validate();
    if (state.value == InputValidationState.valid) {
      flowController.setNewPassword(passwordController.text);
    }
  }

  void _validate() {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) {
      state.value = InputValidationState.invalid;
      return;
    }

    final result = PasswordPolicy.validate(password);

    if (result != PasswordValidationResult.valid) {
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
    final result = PasswordPolicy.validate(passwordController.text);

    if (result == PasswordValidationResult.valid) return null;
    return AppStrings.passwordError(result);
  }

    String? get confirmPasswordErrorText {
        if (!_submitted) return null;

      if (state.value == InputValidationState.mismatch) {
        return AppStrings.invalidPassword;
      }
      return null;
    }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
