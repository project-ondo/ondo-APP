class SignInResponseModel {
  final String accessToken;
  final String accessTokenExpiration;
  final String refreshToken;
  final String refreshTokenExpiration;

  SignInResponseModel({
    required this.accessToken,
    required this.accessTokenExpiration,
    required this.refreshToken,
    required this.refreshTokenExpiration,
  });

  factory SignInResponseModel.fromJson(Map json) => SignInResponseModel(
    accessToken: json["accessToken"],
    accessTokenExpiration: json["accessTokenExpiration"],
    refreshToken: json["refreshToken"],
    refreshTokenExpiration: json["refreshTokenExpiration"],
  );
}

