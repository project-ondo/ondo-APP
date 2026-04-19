import 'package:get/get.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/presentation/auth/login/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLocalDatasource>(
          () => AuthLocalDatasourceImpl(),
      fenix: true,
    );

    Get.lazyPut<SplashController>(
          () => SplashController(localDatasource: Get.find()),
    );
  }
}