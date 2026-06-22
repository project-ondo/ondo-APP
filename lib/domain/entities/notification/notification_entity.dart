import 'package:ondo/core/constants/notification_type.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/data/models/notification/response/notification_model.dart';

class NotificationEntity {
  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final String target;
  final bool read;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.target,
    required this.read,
    required this.createdAt,
  });

  factory NotificationEntity.fromNotificationModel(NotificationModel model) =>
      NotificationEntity(
        id: model.id,
        type: model.type,
        title: model.title,
        body: model.body,
        target: model.target,
        read: model.read,
        createdAt: AppDateUtils.parseUtc(model.createdAt),
      );

  NotificationEntity copyWith({bool? read}) => NotificationEntity(
    id: id,
    type: type,
    title: title,
    body: body,
    target: target,
    read: read ?? this.read,
    createdAt: createdAt,
  );
}
