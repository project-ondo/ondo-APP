import 'package:get/get.dart';
import 'package:ondo/core/env.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/router/bindings/chat_binding.dart';
import 'package:ondo/core/router/bindings/community_binding.dart';
import 'package:ondo/core/router/bindings/home_binding.dart';
import 'package:ondo/core/router/bindings/notification_binding.dart';
import 'package:ondo/core/router/bindings/profile_binding.dart';
import 'package:ondo/core/router/bindings/user_binding.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/presentation/navigation/controllers/navigation_controller.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(Env.apiBaseUrl),
      fenix: true,
    );
    Get.lazyPut<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(),
      fenix: true,
    );

    /// 인증 token을 포함하는 client 등록
    Get.lazyPut(
      () => AuthClient(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
        onAuthFailed: () => appRouter.go(RoutePaths.login),
      ),
      fenix: true,
    );

    /// 전 화면 공통 controller 등록
    Get.lazyPut<NavigationController>(() => NavigationController());
    NotificationBinding().dependencies();
    Get.lazyPut(() => PostController());

    UserBinding().dependencies();

    /// 각 화면 Binding
    HomeBinding().dependencies();
    CommunityBinding().dependencies();
    ChatBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
