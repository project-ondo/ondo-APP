import 'package:ondo/domain/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> loadMyNotificationModel(int size, int page);

  Future<int> loadUnreadNotificationCount();
}
