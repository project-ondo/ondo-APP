import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class DeleteAllReadNotificationsUseCase {
  final NotificationRepository repository;

  DeleteAllReadNotificationsUseCase({required this.repository});

  Future<bool> call() async {
    return repository.deleteAllReadNotifications();
  }
}
