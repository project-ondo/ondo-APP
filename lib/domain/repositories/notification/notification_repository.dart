import 'package:ondo/domain/entities/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> loadMyNotificationModel(int size, int page);

  Future<int> loadUnreadNotificationCount();

  Future<int> readAllNotification();

}
