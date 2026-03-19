class EmailVerifyRequestModel {
  final String email;
  final String code;

  EmailVerifyRequestModel({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
  };
}
