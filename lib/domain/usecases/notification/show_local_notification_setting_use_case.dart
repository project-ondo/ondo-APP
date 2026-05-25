import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class ShowLocalNotificationUseCase {
  final NotificationRepository repository;

  ShowLocalNotificationUseCase({required this.repository});

  Future<void> call({
    required int id,
    required String title,
    required String body,
  }) async {
    await repository.showLocalNotification(
      id: id,
      title: title,
      body: body,
    );
  }
}
