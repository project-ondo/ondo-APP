import 'package:ondo/domain/notification/notification_entity.dart';
import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class LoadMyNotificationListUseCase {
  final NotificationRepository repository;

  LoadMyNotificationListUseCase({required this.repository});

  Future<List<NotificationEntity>> call({
    required int size,
    required int page,
  }) async {
    return (await repository.loadMyNotificationModel(size, page));
  }
}
