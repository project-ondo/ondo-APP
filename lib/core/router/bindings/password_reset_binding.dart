import 'package:get/get.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_completed_controller.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_controller.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_email_code_controller.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_password_controller.dart';

class PasswordResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordResetFlowController>(
      () => PasswordResetFlowController(),
      fenix: true,
    );
    Get.lazyPut<PasswordResetController>(() => PasswordResetController());
    Get.lazyPut<PasswordResetEmailCodeController>(
      () => PasswordResetEmailCodeController(),
    );
    Get.lazyPut<PasswordResetPasswordController>(
      () => PasswordResetPasswordController(),
    );
    Get.lazyPut<PasswordResetCompletedController>(
      () => PasswordResetCompletedController(),
    );
  }
}
