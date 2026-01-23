import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';

enum EmailCodeState {
  initial,
  invalid,
  valid,
}

class EmailCodeInputController extends GetxController {
  static const String tempEmailCode = '111111';

  late final String email;

  late final TextEditingController emailCodeTextController;

  final Rx<EmailCodeState> codeState = EmailCodeState.initial.obs;

  bool get hasCodeInput => emailCodeTextController.text.trim().isNotEmpty;

  bool get isButtonEnabled => hasCodeInput;

  bool get hasError => codeState.value == EmailCodeState.invalid;

  String get errorMessage => AppStrings.invalidEmailCode;

  @override
  void onInit() {
    super.onInit();

    emailCodeTextController = TextEditingController();

    email = Get.arguments?['email'] ?? '';

    emailCodeTextController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    if (codeState.value == EmailCodeState.invalid) {
      codeState.value = EmailCodeState.initial;
    }
    update();
  }

  void verifyEmailCode() {
    final inputCode = emailCodeTextController.text.trim();

    if (inputCode == tempEmailCode) {
      codeState.value = EmailCodeState.valid;
    } else {
      codeState.value = EmailCodeState.invalid;
    }
    update();
  }

  @override
  void onClose() {
    emailCodeTextController.dispose();
    super.onClose();
  }
}
