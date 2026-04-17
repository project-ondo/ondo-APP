import 'package:get/get.dart';
import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/notification/notification_repository_impl.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';

import '../../../presentation/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    ///notification관련 api class
    final datasource = NotificationRemoteDatasource(
      client: Get.find<AuthClient>(),
    );
    final repository = NotificationRepositoryImpl(remoteDatasource: datasource);
    final loadMyNotificationListUseCase = LoadMyNotificationListUseCase(
      repository: repository,
    );
    final loadUnreadNotificationCountUseCase =
        LoadUnreadNotificationCountUseCase(repository: repository);

    ///binding 등록
    Get.lazyPut<NotificationRemoteDatasource>(() => datasource);
    Get.lazyPut<NotificationRepositoryImpl>(() => repository);

    Get.lazyPut<LoadMyNotificationListUseCase>(
      () => loadMyNotificationListUseCase,
    );
    Get.lazyPut<LoadUnreadNotificationCountUseCase>(
      () => loadUnreadNotificationCountUseCase,
    );

    ///notification controller 등록
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        loadMyNotificationListUseCase: loadMyNotificationListUseCase,
        loadUnreadNotificationCountUseCase: loadUnreadNotificationCountUseCase,
      ),
    );
  }
}
