import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum IntroductionState {
  initial,
  valid,
  invalid,
}

class IntroductionInputController extends GetxController {
  static const int maxLength = 200;

  final TextEditingController introductionController = TextEditingController();

  IntroductionState state = IntroductionState.initial;

  bool get canProceed => state != IntroductionState.invalid;

  @override
  void onInit() {
    super.onInit();
    introductionController.addListener(_validate);
  }

  void _validate() {
    final text = introductionController.text;

    if (text.isEmpty) {
      state = IntroductionState.valid;
    } else if (text.length > maxLength) {
      state = IntroductionState.invalid;
    } else {
      state = IntroductionState.valid;
    }

    update();
  }

  String? get errorText {
    if (state == IntroductionState.invalid &&
        introductionController.text.length > maxLength) {
      return '자기소개는 $maxLength자 이내로 작성해주세요';
    }

    return null;
  }

  String get sanitizedValue => introductionController.text.trim();

  @override
  void onClose() {
    introductionController.dispose();
    super.onClose();
  }
}
