import 'package:get/get.dart';
import 'package:ondo/core/env.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/auth/auth_repository_impl.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';
import 'package:ondo/domain/usecases/auth/sign_in_use_case.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    /// 인증 관련 dataSource 등록
    Get.lazyPut<AuthRemoteDatasource>(
          () => AuthRemoteDatasource(Env.apiBaseUrl),
    );
    Get.lazyPut<AuthLocalDatasource>(
          () => AuthLocalDatasourceImpl(),
    );

    /// 인증 관련 repository 등록
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      ),
    );

    /// 로그인 usecase 등록
    Get.lazyPut<SignInUseCase>(
          () => SignInUseCase(repository: Get.find<AuthRepository>()),
    );

    /// 이미지 업로드용 AuthClient 등록
    Get.lazyPut<AuthClient>(
          () => AuthClient(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      ),
    );

    /// 미디어 업로드용 datasource 등록
    Get.lazyPut<MediaRemoteDatasource>(
          () => MediaRemoteDatasource(client: Get.find<AuthClient>()),
    );

    /// 최종적으로 LoginController 등록
    Get.lazyPut<LoginController>(
          () => LoginController(
        signInUseCase: Get.find<SignInUseCase>(),
        mediaRemoteDatasource: Get.find<MediaRemoteDatasource>(),
      ),
    );
  }
}