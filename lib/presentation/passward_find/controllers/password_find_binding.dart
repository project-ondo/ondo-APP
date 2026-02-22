import 'package:get/get.dart';
import 'package:ondo/presentation/passward_find/controllers/password_find_controller.dart';
import 'package:ondo/presentation/passward_find/controllers/password_find_email_code_controller.dart';

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