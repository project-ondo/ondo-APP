import 'package:get/get.dart';
import 'package:ondo/presentation/auth/password_find/controllers/password_find_controller.dart';
import 'package:ondo/presentation/auth/password_find/controllers/password_find_email_code_controller.dart';

class PasswordFindBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
          () => ForgotPasswordController(),
    );
    Get.lazyPut<PasswordFindEmailCodeInputController>(
          () => PasswordFindEmailCodeInputController(),
    );
  }
}