import 'package:ondo/data/models/notification/response/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> loadMyNotificationModel(int size, int page);
}
