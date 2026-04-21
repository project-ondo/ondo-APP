import 'package:ondo/data/models/user/response/user_model.dart';

class UserEntity {
  final String publicId;
  final String displayName;
  final String gender;
  final String major;
  final List<String> interests;
  final String? profileImageKey;
  final double ratingAverage;
  final int ratingCount;

  UserEntity({
    required this.publicId,
    required this.displayName,
    required this.gender,
    required this.major,
    required this.interests,
    required this.profileImageKey,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory UserEntity.fromUserModel(UserModel model) =>
      UserEntity(
        publicId: model.publicId,
        displayName: model.displayName,
        gender: model.gender,
        major: model.major,
        interests: model.interests,
        profileImageKey: model.profileImageKey,
        ratingAverage: model.ratingAverage,
        ratingCount: model.ratingCount,
      );
}
