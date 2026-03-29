class EmailVerifyResponseModel {
  final bool success;
  final String message;
  final EmailVerifyData data;

  EmailVerifyResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EmailVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return EmailVerifyResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? '',
      data: EmailVerifyData.fromJson(json["data"]),
    );
  }
}

class EmailVerifyData {
  final String verificationToken;

  EmailVerifyData({
    required this.verificationToken,
  });

  factory EmailVerifyData.fromJson(Map<String, dynamic> json) {
    return EmailVerifyData(
      verificationToken: json["verificationToken"],
    );
  }
}
