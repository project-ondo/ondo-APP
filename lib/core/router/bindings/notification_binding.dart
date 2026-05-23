import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/data/datasource/notification/notification_local_datasource.dart';
import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/notification/notification_repository_impl.dart';
import 'package:ondo/domain/usecases/notification/delete_all_read_notifications_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_all_notification_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_notification_use_case.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {

  @override
  void dependencies() {
    /// notification 관련 localDatasource 등록
    Get.lazyPut<NotificationLocalDatasource>(
      () => NotificationLocalDatasource(),
      fenix: true,
    );

    /// notification 관련 remoteDatasource 등록
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasource(
        client: Get.find<AuthClient>(),
      ),
    );

    /// notification 관련 repository 등록
    Get.lazyPut<NotificationRepositoryImpl>(
      () => NotificationRepositoryImpl(
        remoteDatasource: Get.find<NotificationRemoteDatasource>(),
        localDatasource: Get.find<NotificationLocalDatasource>(),
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
    Get.lazyPut<ReadNotificationUseCase>(
      () => ReadNotificationUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );
    Get.lazyPut<DeleteAllReadNotificationsUseCase>(
      () => DeleteAllReadNotificationsUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );

    /// notification controller 등록
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        deleteAllReadNotificationsUseCase:
            Get.find<DeleteAllReadNotificationsUseCase>(),
        readNotificationUseCase: Get.find<ReadNotificationUseCase>(),
        readAllNotificationUseCase: Get.find<ReadAllNotificationUseCase>(),
        loadMyNotificationListUseCase:
            Get.find<LoadMyNotificationListUseCase>(),
        loadUnreadNotificationCountUseCase:
            Get.find<LoadUnreadNotificationCountUseCase>(),
      ),
    );

    /// localDatasource 초기화 (알림 권한 요청 + 탭 시 GoRouter 라우팅 설정)
    ///
    /// init()은 비동기지만 dependencies()는 동기 메서드이므로 fire-and-forget으로 호출한다.
    /// 권한 요청 및 플러그인 초기화가 완료되기 전에 알림이 발송될 가능성이 낮으므로
    /// 현재 구조에서는 허용 가능한 트레이드오프다.
    Get.find<NotificationLocalDatasource>().init(
      onNotificationTap: () {
        final context = Get.key.currentContext;
        if (context != null) {
          GoRouter.of(context).push(RoutePaths.notification);
        }
      },
    );
  }
}
