import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/notification/notification_entity.dart';
import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class LoadMyNotificationListUseCase {
  final NotificationRepository repository;

  LoadMyNotificationListUseCase({required this.repository});

  Future<ListableWrapper<NotificationEntity>> call({
    required int size,
    required int page,
  }) {
    return repository.loadMyNotificationModel(size, page);
  }
}
