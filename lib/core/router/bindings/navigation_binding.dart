import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/auth_binding.dart';
import 'package:ondo/core/router/bindings/notification_binding.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../presentation/search/controllers/main_top_bar_search_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();

    /// 전 화면 공통 controller 등록
    NotificationBinding().dependencies();
    Get.lazyPut<MainTopBarSearchController>(() => MainTopBarSearchController());
    Get.lazyPut(() => PostController());

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
  }
}
