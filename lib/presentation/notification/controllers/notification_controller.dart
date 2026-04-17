import 'package:get/get.dart';
import 'package:ondo/domain/notification/notification_entity.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';
class NotificationController extends GetxController {
  final List<NotificationEntity> _cacheNotificationList = [];
  final RxList<NotificationEntity> viewNotificationList =
      <NotificationEntity>[].obs;

  final RxInt notificationCount = 0.obs;

  final LoadMyNotificationListUseCase loadMyNotificationListUseCase;
  final LoadUnreadNotificationCountUseCase loadUnreadNotificationCountUseCase;

  NotificationController({
    required this.loadMyNotificationListUseCase,
    required this.loadUnreadNotificationCountUseCase,
  });

  @override
  void onInit() {
    _loadMyNotificationList();
    _loadUnreadNotificationCount();
    super.onInit();
  }

  Future<void> _loadMyNotificationList() async {
    //TODO : 화면 연동 과정에서 범위 맞추기
    _cacheNotificationList.assignAll(
      await loadMyNotificationListUseCase.call(size: 20, page: 0),
    );
    viewNotificationList.assignAll(_cacheNotificationList);
  }

  Future<void> _loadUnreadNotificationCount() async {
    notificationCount.value = await loadUnreadNotificationCountUseCase.call();
  }

  void clear() {
    viewNotificationList.clear();
    notificationCount.value = 0;
  }
}
