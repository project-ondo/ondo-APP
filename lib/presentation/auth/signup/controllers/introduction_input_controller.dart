import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';


class IntroductionInputController extends GetxController {
  static const int maxLength = 200;

  final TextEditingController introductionController =
  TextEditingController();

  InputValidationState state = InputValidationState.initial;

  bool get isValid => state == InputValidationState.valid;

  bool get canProceed => isValid;

  @override
  void onInit() {
    super.onInit();
    introductionController.addListener(_validate);
  }

  void _validate() {
    final text = introductionController.text.trim();

    if (text.isEmpty) {
      state = InputValidationState.initial;
    } else if (text.length > maxLength) {
      state = InputValidationState.invalid;
    } else {
      state = InputValidationState.valid;
    }

    update();
  }

  String? get errorText {
    if (state == InputValidationState.invalid) {
      return '자기소개는 $maxLength자 이내로 작성해주세요';
    }
    return null;
  }

  bool get hasError => state == InputValidationState.invalid;

  String get sanitizedValue =>
      introductionController.text.trim();

  void submit() {
    if (!isValid) return;
  }

  @override
  void onClose() {
    introductionController.dispose();
    super.onClose();
  }
}
