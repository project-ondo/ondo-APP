import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/domain/usecases/auth/send_email_code_usecase.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';

class SignupEmailInputController extends GetxController {
  final flowController = Get.find<SignupFlowController>();

  final SendEmailCodeUsecase sendEmailCodeUsecase;

  SignupEmailInputController(this.sendEmailCodeUsecase);

  late final TextEditingController emailTextController;

  InputValidationState emailState = InputValidationState.initial;

  bool get hasEmailInput => emailTextController.text.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    emailTextController = TextEditingController();

    // 텍스트 변경 시 자동으로 UI 업데이트
    emailTextController.addListener(() {
      if (emailState == InputValidationState.invalid) {
        emailState = InputValidationState.initial;
      }
      update();
    });
  }

  bool isLoading = false;

  Future<bool> sendEmailCode() async {
    final email = emailTextController.text.trim();

    if (!validateEmail(email)) return false;

    try {
      isLoading = true;
      update();

      await sendEmailCodeUsecase(email);

      flowController.setEmail(email);

      return true;
    } catch (e) {
      emailState = InputValidationState.invalid;
      update();

      Get.snackbar(
        AppStrings.emailSendFail,
        AppStrings.retryMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    emailTextController.dispose();
    super.onClose();
  }

  bool validateEmail(String email) {
    if (_isValidEmail(email)) {
      emailState = InputValidationState.valid;
      flowController.setEmail(email);
      update();
      return true;
    } else {
      emailState = InputValidationState.invalid;
      update();
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
