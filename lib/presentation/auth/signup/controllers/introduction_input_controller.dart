import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class IntroductionInputController extends GetxController {
  final TextEditingController introductionController = TextEditingController();

  bool get canProceed => introductionController.text.trim().isNotEmpty;


  void onIntroductionChanged(String value){
    update();
  }

  void submit(){
    if(!canProceed) return;

    log('자기소개 설정: ${introductionController.text}');
  }

  @override
  void onClose() {
    introductionController.dispose();
    super.onClose();
  }
}