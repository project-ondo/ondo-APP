import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/notification/notification_entity.dart';

abstract class NotificationRepository {
  // ─── 서버 알림 ─────────────────────────────────────────────────
  Future<ListableWrapper<NotificationEntity>> loadMyNotificationModel(
    int size,
    int page,
  );

  Future<int> loadUnreadNotificationCount();

  Future<int> readAllNotification();

  Future<bool> readNotification(int id);

  Future<bool> deleteAllReadNotifications();
  // ─── 로컬 알림 발송 ────────────────────────────────────────────
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  });

  // ─── 알림 설정 불러오기 ────────────────────────────────────────
  Future<bool> isPushEnabled();

  Future<bool> isVibrationEnabled();

  Future<bool> isSoundEnabled();

  // ─── 알림 설정 저장 ────────────────────────────────────────────
  Future<void> setPushEnabled(bool value);

  Future<void> setVibrationEnabled(bool value);

  Future<void> setSoundEnabled(bool value);
}
