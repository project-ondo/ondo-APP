import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class ReadAllNotificationUseCase {
  final NotificationRepository repository;

  ReadAllNotificationUseCase({required this.repository});

  Future<void> call() async {
    await repository.readAllNotification();
  }
}
