class UpdateProfileRequestModel {
  final String? displayName;
  final String? bio;
  final String? major;
  final List<String>? interests;
  final String? profileImageKey;

  UpdateProfileRequestModel({
    this.displayName,
    this.bio,
    this.major,
    this.interests,
    this.profileImageKey,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (displayName != null) map['displayName'] = displayName;
    if (bio != null) map['bio'] = bio;
    if (major != null) map['major'] = major;
    if (interests != null) map['interests'] = interests;
    if (profileImageKey != null) map['profileImageKey'] = profileImageKey;
    return map;
  }
}