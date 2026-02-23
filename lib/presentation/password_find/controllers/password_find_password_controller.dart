import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class PasswordResetController extends GetxController {
  static const int mainPasswordLength = 8;
  static const String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

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
        passwordController.text.isNotEmpty ||
            confirmPasswordController.text.isNotEmpty;


    if(_submitted){
      _validate();
    }
  }

  /// 버튼 클릭 시 호출
  void submit() {
    _submitted = true;
    _validate();
  }

  void _validate() {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) {
      state.value = InputValidationState.invalid;
      return;
    }

    if (!_isValidPassword(password)) {
      state.value = InputValidationState.invalid;
      return;
    }

    if (password != confirm) {
      state.value = InputValidationState.mismatch;
      return;
    }

    state.value = InputValidationState.valid;
  }

  bool _isValidPassword(String password) {
    return RegExp(passwordPattern).hasMatch(password);
  }

  bool get canProceed => state.value == InputValidationState.valid;

  String? get passwordErrorText {
    if (!_submitted) return null;

    if (state.value == InputValidationState.invalid) {
      return '$mainPasswordLength자 이상, 영문+숫자 조합이 필요합니다.';
    }
    return null;
  }

  String? get confirmPasswordErrorText {
    if (!_submitted && state.value != InputValidationState.mismatch) return null;

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
