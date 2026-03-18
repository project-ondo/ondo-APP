import 'package:get/get.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';

class PasswordResetCompletedController extends GetxController{
  final flowController = Get.find<PasswordResetFlowController>();
  late final String email;

  @override
  void onInit() {
    super.onInit();
    email = flowController.email;
  }

  @override
  void onClose() {
    super.onClose();
    flowController.clear();
  }
}