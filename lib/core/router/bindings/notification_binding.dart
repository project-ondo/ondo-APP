import 'package:get/get.dart';
import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/notification/notification_repository_impl.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_all_notification_use_case.dart';

import '../../../presentation/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    /// notification 관련 dataSource 등록
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasource(
        client: Get.find<AuthClient>(),
      ),
    );

    /// notification 관련 repository 등록
    Get.lazyPut<NotificationRepositoryImpl>(
      () => NotificationRepositoryImpl(
        remoteDatasource: Get.find<NotificationRemoteDatasource>(),
      ),
    );

    /// notification 관련 usecase 등록
    Get.lazyPut<LoadMyNotificationListUseCase>(
      () => LoadMyNotificationListUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );
    Get.lazyPut<LoadUnreadNotificationCountUseCase>(
      () => LoadUnreadNotificationCountUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );
    Get.lazyPut<ReadAllNotificationUseCase>(
      () => ReadAllNotificationUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );

    ///notification controller 등록
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        readAllNotificationUseCase: Get.find<ReadAllNotificationUseCase>(),
        loadMyNotificationListUseCase:
            Get.find<LoadMyNotificationListUseCase>(),
        loadUnreadNotificationCountUseCase:
            Get.find<LoadUnreadNotificationCountUseCase>(),
      ),
    );
  }
}
