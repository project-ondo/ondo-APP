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


  bool get canSubmit =>
      email != null &&
      password != null &&
      introduction != null &&
      major != null &&
      interests.isNotEmpty;

  void submitInfo(){
    //현재는 디버그 용 코드 서버 연결 후 서버에 값을 보내는 역할 예정
    log('email: $email');
    log('password: $password');
    log('nickname: $nickname');
    log('introduction: $introduction');
    log('interests: $interests');
  }

  //회원가입 설정 값 초기화
  void clear() {
    nickname = null;
    introduction = null;
    major = null;
    interests.clear();
  }
}
