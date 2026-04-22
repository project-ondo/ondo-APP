import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class LoadUnreadNotificationCountUseCase {
  final NotificationRepository repository;

  LoadUnreadNotificationCountUseCase({required this.repository});

  Future<int> call() async {
    return await repository.loadUnreadNotificationCount();
  }
}
