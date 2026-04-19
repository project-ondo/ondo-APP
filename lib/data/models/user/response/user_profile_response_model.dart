class UserProfileResponseModel {
  final bool success;
  final String message;
  final UserProfileDataModel? data;

  UserProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserProfileResponseModel.fromJson(Map json) {
    return UserProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UserProfileDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class UserProfileDataModel {
  final String publicId;
  final String loginId;
  final String email;
  final String displayName;
  final String gender;
  final String major;
  final List<String> interests;
  final String? profileImageKey;
  final String? bio;
  final String role;
  final String status;
  final double ratingAverage;
  final int ratingCount;

  UserProfileDataModel({
    required this.publicId,
    required this.loginId,
    required this.email,
    required this.displayName,
    required this.gender,
    required this.major,
    required this.interests,
    this.profileImageKey,
    this.bio,
    required this.role,
    required this.status,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory UserProfileDataModel.fromJson(Map json) {
    return UserProfileDataModel(
      publicId: json['publicId'] ?? '',
      loginId: json['loginId'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      gender: json['gender'] ?? '',
      major: json['major'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      profileImageKey: json['profileImageKey'],
      bio: json['bio'],
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
    );
  }
}