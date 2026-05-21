import 'package:ondo/data/datasource/notification/notification_local_datasource.dart';
import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/notification/response/notification_model.dart';
import 'package:ondo/domain/entities/notification/notification_entity.dart';
import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;
  final NotificationLocalDatasource localDatasource;

  NotificationRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  // ─── 서버 알림 ─────────────────────────────────────────────────

  @override
  Future<List<NotificationEntity>> loadMyNotificationModel(
    int size,
    int page,
  ) async {
    final ListRequestModel model = ListRequestModel(
      size: size,
      page: page,
    );

    final json = await remoteDatasource.loadMyNotificationList(model);

    if (json == null) return [];

    final res = NotificationDataModel.fromJson(json);

    return res.content
        .map(
          (e) => NotificationEntity.fromNotificationModel(e),
    )
        .toList();
  }

  @override
  Future<int> loadUnreadNotificationCount() async {
    final res = await remoteDatasource.loadUnreadNotificationCount();
    if (res == null) return 0;
    return res;
  }

  @override
  Future<int> readAllNotification() async {
    final res = await remoteDatasource.readAllNotification();
    if (res == null) return 0;
    return res;
  }

  @override
  Future<bool> readNotification(int id) {
    return remoteDatasource.readNotification(id);
  }
}

  // ─── 로컬 알림 발송 ────────────────────────────────────────────

  @override
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await localDatasource.showNotification(id: id, title: title, body: body);
  }

  // ─── 알림 설정 불러오기 ────────────────────────────────────────

  @override
  Future<bool> isPushEnabled() => localDatasource.isPushEnabled();

  @override
  Future<bool> isVibrationEnabled() => localDatasource.isVibrationEnabled();

  @override
  Future<bool> isSoundEnabled() => localDatasource.isSoundEnabled();

  // ─── 알림 설정 저장 ────────────────────────────────────────────

  @override
  Future<void> setPushEnabled(bool value) =>
      localDatasource.setPushEnabled(value);

  @override
  Future<void> setVibrationEnabled(bool value) =>
      localDatasource.setVibrationEnabled(value);

  @override
  Future<void> setSoundEnabled(bool value) =>
      localDatasource.setSoundEnabled(value);
}