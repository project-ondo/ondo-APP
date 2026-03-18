import 'package:get/get.dart';

class SignupFlowController extends GetxController {
  String? email;
  bool isEmailVerified = false;
  String? password;
  String? nickname;
  String? introduction;
  String? profileImagePath;
  String? major;

  Set<String> interests = {};

  bool get isValid {
    return email != null &&
        isEmailVerified &&
        password != null &&
        nickname != null &&
        introduction != null &&
        profileImagePath != null &&
        major != null &&
        interests.isNotEmpty;
  }

  void setNickname(String value) {
    nickname = value;
  }

  void setEmail(String value) {
    email = value;
  }

  void setEmailVerified(bool value) {
    isEmailVerified = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setIntroduction(String value) {
    introduction = value;
  }

  void setMajor(String value) {
    major = value;
  }

  void setProfileImagePath(String? value){
    profileImagePath = value;
  }

  void setInterests(Set<String> value) {
    interests = value;
  }

  void submitInfo() {
    if (!isValid) return;
  }

  void clear() {
    email = null;
    isEmailVerified = false;
    password = null;
    nickname = null;
    introduction = null;
    major = null;
    interests.clear();
    profileImagePath = null;
  }
}
