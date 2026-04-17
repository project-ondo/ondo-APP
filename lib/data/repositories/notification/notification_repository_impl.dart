import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/notification/response/notification_model.dart';
import 'package:ondo/domain/notification/notification_entity.dart';
import 'package:ondo/domain/repositories/notification/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<NotificationEntity>> loadMyNotificationModel(
    int size,
    int page,
  ) async {
    final BaseListRequestModel model = BaseListRequestModel(
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
}
