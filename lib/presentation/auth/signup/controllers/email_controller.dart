import 'package:get/get.dart';

enum EmailInputState {
  initial,
  invalid,
  valid,
}

class EmailController extends GetxController {
  EmailInputState emailState = EmailInputState.initial;

  bool validateEmail(String email) {
    if (_isValidEmail(email)) {
      emailState = EmailInputState.valid;
      update();
      return true;
    } else {
      emailState = EmailInputState.invalid;
      update();
      return false;
    }
  }


  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void resetState() {
    if (emailState == EmailInputState.invalid) {
      emailState = EmailInputState.initial;
      update();
    }
  }
}
