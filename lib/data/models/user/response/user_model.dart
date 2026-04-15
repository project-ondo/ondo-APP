import 'package:ondo/data/models/base/response/base_model.dart';

import '../../base/response/base_data_model.dart';

class UserDataModel extends BaseDataModel<UserModel> {
  UserDataModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElement,
    required super.totalPages,
    required super.last,
  });

  factory UserDataModel.fromJson(Map json) => UserDataModel(
    content:
        (json["content"] as List?)
            ?.map(
              (e) => UserModel.fromJson(e),
            )
            .toList() ??
        [],
    page: json["page"],
    size: json["size"],
    totalElement: json["totalElement"],
    totalPages: json["totalPages"],
    last: json["last"],
  );

  @override
  Map<dynamic, dynamic> toJson() => {
    "content": content.map(
      (e) => e.toJson(),
    ),
    "page": page,
    "size": size,
    "totalElement": totalElement,
    "totalPages": totalPages,
    "last": last,
  };
}

class UserModel extends BaseModel {
  final String publicId;
  final String displayName;
  final String gender;
  final String major;
  final List<String> interests;
  final String? profileImageKey;
  final double ratingAverage;
  final int ratingCount;

  UserModel({
    required this.publicId,
    required this.displayName,
    required this.gender,
    required this.major,
    required this.interests,
    required this.profileImageKey,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory UserModel.fromJson(Map json) => UserModel(
    publicId: json["publicId"],
    displayName: json["displayName"],
    gender: json["gender"],
    major: json["major"],
    interests: (json["interests"] as List).cast<String>(),
    profileImageKey: json["profileImageKey"],
    ratingAverage: json["ratingAverage"],
    ratingCount: json["ratingCount"],
  );

  @override
  Map<dynamic, dynamic> toJson() => {
    "publicId": publicId,
    "displayName": displayName,
    "gender": gender,
    "major": major,
    "interests": interests,
    "profileImageKey": profileImageKey,
    "ratingAverage": ratingAverage,
    "ratingCount": ratingCount,
  };
}
