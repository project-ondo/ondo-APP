import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class UpdateNotificationSettingUseCase {
  final NotificationRepository repository;

  UpdateNotificationSettingUseCase({required this.repository});

  Future<void> setPush(bool value) => repository.setPushEnabled(value);

  Future<void> setVibration(bool value) =>
      repository.setVibrationEnabled(value);

  Future<void> setSound(bool value) => repository.setSoundEnabled(value);
}
