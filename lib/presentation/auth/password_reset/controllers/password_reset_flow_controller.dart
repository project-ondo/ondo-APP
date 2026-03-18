import 'package:get/get.dart';

class PasswordResetFlowController extends GetxController {
  String email = '';
  bool isEmailVerified = false;
  String newPassword = '';

  void setEmail(String value) {
    email = value;
  }

  void setVerificationCode(bool value) {
    isEmailVerified = value;
  }

  void setNewPassword(String value) {
    newPassword = value;
  }

  void clear() {
    email = '';
    isEmailVerified = false;
    newPassword = '';
  }
}
