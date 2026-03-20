import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/domain/usecases/auth/verify_email_code_usecase.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class SignupEmailCodeInputController extends GetxController {
  final flowController = Get.find<SignupFlowController>();

  final VerifyEmailCodeUsecase verifyEmailCodeUsecase = Get.find();

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

  var isLoading = false.obs;

  Future<bool> verifyEmailCode() async {
    if (isLoading.value) return false;

    final inputCode = emailCodeTextController.text.trim();

    if (inputCode.length != 6) {
      codeState.value = InputValidationState.invalid;
      return false;
    }

    try {
      isLoading.value = true;
      final token = await verifyEmailCodeUsecase(email, inputCode);

      codeState.value = InputValidationState.valid;
      flowController.setEmailVerified(true);
      flowController.setVerificationToken(token);

      return true;
    } catch (e ,s) {
      debugPrint('Failed to verify email code: $e\n$s');
      codeState.value = InputValidationState.invalid;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _onCodeChanged() {
    code.value = emailCodeTextController.text;

    if (codeState.value == InputValidationState.invalid) {
      codeState.value = InputValidationState.initial;
    }
  }

  @override
  void onClose() {
    emailCodeTextController.dispose();
    super.onClose();
  }
}
