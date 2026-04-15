import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/repositories/auth/auth_repository_impl.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';
import 'package:ondo/domain/usecases/auth/sign_in_use_case.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    ///인증 관련 dataSource 등록
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(dotenv.env["API_BASE_URL"]!),
    );
    Get.lazyPut<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(),
    );

    ///인증 관련 repository 등록
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      ),
    );

    ///로그인 usecase 등록
    Get.lazyPut<SignInUseCase>(
      () => SignInUseCase(repository: Get.find<AuthRepository>()),
    );

    ///최종적으로 LoginController 등록
    Get.lazyPut<LoginController>(
      () => LoginController(signInUseCase: Get.find<SignInUseCase>()),
    );
  }
}
