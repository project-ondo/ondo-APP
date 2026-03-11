import 'dart:developer';

import 'package:get/get.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';

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

class SignupMajorInterestController extends GetxController {
  final SignupFlowController flowController = Get.find();
  MajorCategory? selectedMajor;

  final Set<MajorCategory> selectedInterests = {};

  void selectMajor(MajorCategory value) {
    selectedMajor = value;
    update();
  }

  void toggleInterest(MajorCategory value) {
    if (selectedInterests.contains(value)) {
      selectedInterests.remove(value);
    } else {
      selectedInterests.add(value);
    }
    update();
  }

  bool get canProceed => selectedMajor != null && selectedInterests.isNotEmpty;

  void submit()   {
    if (!canProceed) return;

    final major = selectedMajor!;
    flowController.setMajor(major.name);
    flowController.setInterests(selectedInterests.map((e) => e.name).toSet());

    log('전공: ${major.name}');
    log(
      '관심분야: ${selectedInterests.map(
        (e) => e.name,
      ).toList()}',
    );
  }
}
