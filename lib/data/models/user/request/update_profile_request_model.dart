class UpdateProfileRequestModel {
  final String? displayName;
  final String? gender;
  final String? major;
  final List<String>? interests;
  final String? bio;

  UpdateProfileRequestModel({
    this.displayName,
    this.gender,
    this.major,
    this.interests,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (displayName != null) map['displayName'] = displayName;
    if (gender != null) map['gender'] = gender;
    if (major != null) map['major'] = major;
    if (interests != null) map['interests'] = interests;
    if (bio != null) map['bio'] = bio;
    return map;
  }
}