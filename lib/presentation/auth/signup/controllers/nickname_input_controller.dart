import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';


class NicknameInputController extends GetxController {
  final TextEditingController nicknameController = TextEditingController();

  final signupFlowController = Get.find<SignupFlowController>();
  InputValidationState state = InputValidationState.initial;

  bool get hasInput => nicknameController.text.trim().isNotEmpty;

  bool get conSubmit => hasInput;

  @override
  void onInit() {
    super.onInit();

    nicknameController.addListener(
          () {
        update();
      },
    );
  }

  bool validateNickname(){
    final nickname = nicknameController.text.trim();

    if(nickname == 'test1')
    {
      state = InputValidationState.invalid;
      update();
      return false;
    }

    signupFlowController.setNickname(nickname);
    state = InputValidationState.valid;
    update();
    log('닉네임 설정: $nickname');
    return true;
  }

  String? get errorText {
    if(state == InputValidationState.invalid){
      return AppStrings.alreadyRegisteredMickName;
    }
    return null;
  }

  @override
  void onClose() {
    nicknameController.dispose();
    super.onClose();
  }
}
