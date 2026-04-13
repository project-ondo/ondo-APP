abstract class AuthLocalDatasource {

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> saveToken(String refreshToken, String accessToken);

  Future<void> deleteAll();
}
