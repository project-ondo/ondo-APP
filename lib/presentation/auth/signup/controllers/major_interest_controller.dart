import 'dart:developer';

import 'package:get/get.dart';

class MajorInterestController extends GetxController{
  String? selectedMajor;

  final Set<String> selectedInterests = {};

  void selectMajor(String value){
    selectedMajor = value;
    update();
  }

  void toggleInterest(String value){
    if(selectedInterests.contains(value)){
      selectedInterests.remove(value);
    }else{
      selectedInterests.add(value);
    }
    update();
  }

  bool get canProceed => selectedMajor != null && selectedInterests.isNotEmpty;

  void submit(){
    log('전공: $selectedMajor');
    log('관심분야: $selectedInterests');
  }
}