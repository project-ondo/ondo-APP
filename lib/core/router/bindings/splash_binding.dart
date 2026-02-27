import 'package:get/get.dart';
import 'package:ondo/presentation/auth/login/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
