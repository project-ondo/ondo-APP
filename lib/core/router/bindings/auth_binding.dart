import 'package:get/get.dart';

import '../../../data/datasource/auth/auth_local_datasource_impl.dart';
import '../../../data/datasource/auth/auth_remote_datasource.dart';
import '../../../data/datasource/base/auth_local_datasource.dart';
import '../../../data/network/clients/auth_client.dart';
import '../../env.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRemoteDatasource>()) {
      Get.lazyPut<AuthRemoteDatasource>(
        () => AuthRemoteDatasource(Env.apiBaseUrl),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AuthLocalDatasource>()) {
      Get.lazyPut<AuthLocalDatasource>(
        () => AuthLocalDatasourceImpl(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthClient>()) {
      Get.lazyPut(
        () => AuthClient(
          localDatasource: Get.find<AuthLocalDatasource>(),
          remoteDatasource: Get.find<AuthRemoteDatasource>(),
        ),
        fenix: true,
      );
    }
  }
}
