import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class LoadNotificationSettingUseCase {
  final NotificationRepository repository;

  LoadNotificationSettingUseCase({required this.repository});

  Future<Map<String, bool>> call() async {
    final isPush = await repository.isPushEnabled();
    final isVibration = await repository.isVibrationEnabled();
    final isSound = await repository.isSoundEnabled();

    return {
      'push': isPush,
      'vibration': isVibration,
      'sound': isSound,
    };
  }
}
