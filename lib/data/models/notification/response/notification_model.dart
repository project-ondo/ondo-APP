import 'package:ondo/data/models/base/response/base_model.dart';

import '../../base/response/base_data_model.dart';

class NotificationDataModel extends BaseDataModel<NotificationModel> {
  NotificationDataModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.last,
  });

  factory NotificationDataModel.fromJson(Map json) => NotificationDataModel(
    content: (json["content"] as List)
        .map(
          (e) => NotificationModel.fromJson(e),
        )
        .toList(),
    page: json["page"],
    size: json["size"],
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    last: json["last"],
  );
}

class NotificationModel extends BaseModel {
  final int id;
  final String type;
  final String title;
  final String body;
  final String target;
  final bool read;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.target,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map json) => NotificationModel(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    body: json["body"],
    target: json["target"],
    read: json["read"],
    createdAt: json["createdAt"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "body": body,
    "target": target,
    "read": read,
    "createdAt": createdAt,
  };
}
