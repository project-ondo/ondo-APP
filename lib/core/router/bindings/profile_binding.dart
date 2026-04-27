import 'package:get/get.dart';
import 'package:ondo/core/env.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/auth/auth_repository_impl.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';
import 'package:ondo/domain/usecases/auth/logout_usecase.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthLocalDatasource>()) {
      Get.lazyPut<AuthLocalDatasource>(
            () => AuthLocalDatasourceImpl(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthRemoteDatasource>()) {
      Get.lazyPut<AuthRemoteDatasource>(
            () => AuthRemoteDatasource(Env.apiBaseUrl),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthClient>()) {
      Get.lazyPut<AuthClient>(
            () => AuthClient(
          localDatasource: Get.find<AuthLocalDatasource>(),
          remoteDatasource: Get.find<AuthRemoteDatasource>(),
        ),
        fenix: true,
      );
    }

    /// AuthRepository 등록 (LogoutUseCase에 필요)
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      ),
    );

    /// LogoutUseCase 등록 (localDatasource 주입)
    Get.lazyPut<LogoutUseCase>(
          () => LogoutUseCase(
        repository: Get.find<AuthRepository>(),
        localDatasource: Get.find<AuthLocalDatasource>(),
      ),
    );

    /// 프로필 관련 datasource 등록
    Get.lazyPut<ProfileRemoteDatasource>(
          () => ProfileRemoteDatasource(client: Get.find<AuthClient>()),
      fenix: true,
    );

    /// Controller 등록
    Get.lazyPut<MyProfileController>(
          () => MyProfileController(),
    );
  }
}