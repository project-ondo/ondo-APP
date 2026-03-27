class SignupResponseModel {
  final bool success;
  final String message;
  final SignupResponseDataModel? data;

  SignupResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? SignupResponseDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class SignupResponseDataModel {
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

  SignupResponseDataModel({
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

  factory SignupResponseDataModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseDataModel(
      publicId: json['publicId'],
      loginId: json['loginId'],
      email: json['email'],
      displayName: json['displayName'],
      gender: json['gender'],
      major: json['major'],
      interests: List<String>.from(json['interests']),
      profileImageKey: json['profileImageKey'],
      bio: json['bio'],
      role: json['role'],
      status: json['status'],
      ratingAverage: (json['ratingAverage'] as num).toDouble(),
      ratingCount: json['ratingCount'],
    );
  }
}