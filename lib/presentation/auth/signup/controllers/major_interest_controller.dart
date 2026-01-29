import 'dart:developer';

import 'package:get/get.dart';

enum MajorCategory {
  frontEnd,
  backEnd,
  ai,
  devops,
  planning,
  design,
  android,
  ios,
  cloud,
}


extension MajorCategoryX on MajorCategory {
  String get label {
    switch (this) {
      case MajorCategory.frontEnd:
        return 'FrontEnd';
      case MajorCategory.backEnd:
        return 'BackEnd';
      case MajorCategory.ai:
        return 'AI';
      case MajorCategory.devops:
        return 'DevOps';
      case MajorCategory.planning:
        return '기획';
      case MajorCategory.design:
        return 'UI/UX';
      case MajorCategory.android:
        return 'Android';
      case MajorCategory.ios:
        return 'iOS';
      case MajorCategory.cloud:
        return 'Cloud';
    }
  }
}

class MajorInterestController extends GetxController{
  MajorCategory? selectedMajor;

  final Set<MajorCategory> selectedInterests = {};

  void selectMajor(MajorCategory value){
    selectedMajor = value;
    update();
  }

  void toggleInterest(MajorCategory value){
    if(selectedInterests.contains(value)){
      selectedInterests.remove(value);
    }else{
      selectedInterests.add(value);
    }
    update();
  }

  bool get canProceed => selectedMajor != null && selectedInterests.isNotEmpty;

  void submit(){
    log('전공: ${selectedMajor?.name}');
    log('관심분야: ${selectedInterests.map((e) => e.name,).toList()}');
  }
}