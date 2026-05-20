abstract class AuthLocalDatasource {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getAccessTokenExpiration();

  Future<String?> getRefreshTokenExpiration();

  Future<void> saveToken({
    required String accessToken,
    required String accessTokenExpiration,
    required String refreshToken,
    required String refreshTokenExpiration,
  });

  Future<void> saveMyPublicId(String publicId);

  Future<String?> getMyPublicId();

  Future<void> deleteAll();

  Future<void> deleteAccessToken();

  Future<void> deleteRefreshToken();
}
