import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class IntroductionInputController extends GetxController {
  final TextEditingController introductionController = TextEditingController();

  bool isSubmitted = false;

  bool get isValid => introductionController.text.trim().isNotEmpty;

  String? get errorText{
    if (!isSubmitted) return null;
    if (!isValid) return "자기소개는 필수 입력 항목입니다.";
    return null;
  }

  bool get hasError => errorText != null;


  void onIntroductionChanged(String value){
    update();
  }

  void submit(){
    isSubmitted = true;
    update();
    if(!isValid) return;

    log('자기소개 설정: ${introductionController.text}');
  }

  @override
  void onClose() {
    introductionController.dispose();
    super.onClose();
  }
}