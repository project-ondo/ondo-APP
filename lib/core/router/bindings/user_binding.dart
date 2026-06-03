import 'package:get/get.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/user/user_repository_impl.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    /// user 관련 dataSource, repository 등록
    Get.lazyPut<UserRemoteDatasource>(
      () => UserRemoteDatasource(client: Get.find<AuthClient>()),
    );
    Get.lazyPut<UserRepositoryImpl>(
      () => UserRepositoryImpl(
        remoteDatasource: Get.find<UserRemoteDatasource>(),
      ),
    );

    /// user 검색 usecase 등록
    Get.lazyPut(
      () => UserSearchUseCase(repository: Get.find<UserRepositoryImpl>()),
    );

    Get.lazyPut(
      () => LoadRecommendUsersUseCase(
        repository: Get.find<UserRepositoryImpl>(),
      ),
    );
  }
}
