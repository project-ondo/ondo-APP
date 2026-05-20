import 'package:get/get.dart';
import 'package:ondo/domain/entities/notification/notification_entity.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_all_notification_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_notification_use_case.dart';

class NotificationController extends GetxController {
  final RxList<NotificationEntity> viewNotificationList =
      <NotificationEntity>[].obs;

  final RxInt newNotificationCount = 0.obs;

  final LoadMyNotificationListUseCase loadMyNotificationListUseCase;
  final LoadUnreadNotificationCountUseCase loadUnreadNotificationCountUseCase;
  final ReadAllNotificationUseCase readAllNotificationUseCase;
  final ReadNotificationUseCase readNotificationUseCase;

  NotificationController({
    required this.loadMyNotificationListUseCase,
    required this.loadUnreadNotificationCountUseCase,
    required this.readAllNotificationUseCase,
    required this.readNotificationUseCase,
  });

  @override
  void onInit() {
    _loadMyNotificationList();
    _loadUnreadNotificationCount();
    super.onInit();
  }

  Future<void> _loadMyNotificationList() async {
    //TODO : 화면 연동 과정에서 범위 맞추기
    viewNotificationList.assignAll(
      await loadMyNotificationListUseCase.call(size: 20, page: 0),
    );
  }

  Future<void> _loadUnreadNotificationCount() async {
    newNotificationCount.value = await loadUnreadNotificationCountUseCase
        .call();
  }

  Future<void> _readAllNotification() async {
    await readAllNotificationUseCase.call();
  }

  Future<bool> _readNotification(int id) async {
    return await readNotificationUseCase.call(id);
  }

  Future<void> read(NotificationEntity notification) async {
    if (await _readNotification(notification.id)) {
      final index = viewNotificationList.indexWhere(
        (e) => e.id == notification.id,
      );
      if (index >= 0) {
        viewNotificationList[index] = notification.copyWith(read: true);
      }
    }
  }

  Future<void> readAll() async {
    await _readAllNotification();
    viewNotificationList.assignAll(
      viewNotificationList.map((e) => e.copyWith(read: true)),
    );
    newNotificationCount.value = 0;
  }

  void clear() {
    //TODO : 읽은 알림 모두 삭제 api 개발
    viewNotificationList.removeWhere((element) => element.read == true);
  }
}
