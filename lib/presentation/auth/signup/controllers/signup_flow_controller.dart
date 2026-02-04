import 'dart:developer';

import 'package:get/get.dart';

class SignupFlowController extends GetxController {
  String? email;
  String? password;

  //"KIEYU" 부분은 테스트용 (라우팅 작업 시 삭제)
  String? nickname = "KIEYU";
  String? introduction;
  String? profileImagePath;

  String? major;
  Set<String> interests = {};

  void setNickname(String value) {
    nickname = value;
    update();
  }

  void setEmail(String value) => email = value;

  void setPassword(String value) => password = value;

  void setIntroduction(String value) => introduction = value;

  void setMajor(String value) => major = value;

  void setInterests(Set<String> value) => interests = value;

  void submitInfo() {
    if (email != null &&
        password != null &&
        introduction != null &&
        major != null &&
        interests.isNotEmpty) {
      log('email: $email');
      log('password: $password');
      log('nickname: $nickname');
      log('major: $major');
      log('introduction: $introduction');
      log('interests: $interests');
      log('profileImagePath: $profileImagePath');
    }
  } 

  //회원가입 설정 값 초기화
  void clear() {
    email = null;
    password = null;
    nickname = null;
    introduction = null;
    major = null;
    interests.clear();
    profileImagePath = null;
  }
}
