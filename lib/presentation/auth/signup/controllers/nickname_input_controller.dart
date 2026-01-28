import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';

enum NicknameInputState {
  initial,
  valid,
  invalid,
}

class NicknameInputController extends GetxController {
  final TextEditingController nicknameController = TextEditingController();

  final signupFlowController = Get.find<SignupFlowController>();

  NicknameInputState state = NicknameInputState.initial;

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

  void validateNickname(){
    final nickname = nicknameController.text.trim();

    if(nickname == 'test1')
    {
      state = NicknameInputState.invalid;
      update();
      return;
    }

    signupFlowController.setNickname(nickname);

    state = NicknameInputState.valid;
    update();
    log('닉네임 설정: $nickname');
  }

  String? get errorText {
    if(state == NicknameInputState.invalid){
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
