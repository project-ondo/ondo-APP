class EmailVerifyResponseModel {
  final bool success;
  final String message;
  final String? verificationToken;

  EmailVerifyResponseModel({
    required this.success,
    required this.message,
    required this.verificationToken,
  });

  factory EmailVerifyResponseModel.fromJson(Map<String, dynamic> json) =>
      EmailVerifyResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        verificationToken: json["data"]?["verificationToken"],
      );
}
