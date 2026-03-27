class SignupRequestModel {
  final String verificationToken;
  final String loginId;
  final String password;
  final String displayName;
  final String gender;
  final String major;
  final List<String> interests;
  final String? profileImageKey;

  SignupRequestModel({
    required this.verificationToken,
    required this.loginId,
    required this.password,
    required this.displayName,
    required this.gender,
    required this.major,
    required this.interests,
    this.profileImageKey,
  });

  Map<String, dynamic> toJson() => {
    'verificationToken': verificationToken,
    'loginId': loginId,
    'password': password,
    'displayName': displayName,
    'gender': gender,
    'major': major,
    'interests': interests,
    'profileImageKey': profileImageKey,
  };
}
