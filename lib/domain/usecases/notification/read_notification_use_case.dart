import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class ReadNotificationUseCase {
  final NotificationRepository repository;

  ReadNotificationUseCase({required this.repository});

  Future<bool> call(int id) async {
    return repository.readNotification(id);
  }
}
