import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final FlutterSecureStorage store = FlutterSecureStorage();

  //TODO : 환경 변수 설정
  static const String _accessTokenKey = "ACCESS_TOKEN";
  static const String _refreshTokenKey = "REFRESH_TOKEN";
  static const String _accessTokenExpirationKey = "ACCESS_TOKEN_EXPIRATION";
  static const String _refreshTokenExpirationKey = "REFRESH_TOKEN_EXPIRATION";

  @override
  Future<String?> getAccessToken() async =>
      await store.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() async =>
      await store.read(key: _refreshTokenKey);

  @override
  Future<String?> getAccessTokenExpiration() async =>
      await store.read(key: _accessTokenExpirationKey);

  @override
  Future<String?> getRefreshTokenExpiration() async =>
      await store.read(key: _refreshTokenExpirationKey);

  @override
  Future<void> saveToken({
    required String accessToken,
    required String accessTokenExpiration,
    required String refreshToken,
    required String refreshTokenExpiration,
  }) async {
    await store.write(key: _accessTokenKey, value: accessToken);
    await store.write(
      key: _accessTokenExpirationKey,
      value: accessTokenExpiration,
    );
    await store.write(key: _refreshTokenKey, value: refreshToken);
    await store.write(
      key: _refreshTokenExpirationKey,
      value: refreshTokenExpiration,
    );
  }

  @override
  Future<void> deleteAll() async => await store.deleteAll();

  @override
  Future<void> deleteAccessToken() async =>
      await store.delete(key: _accessTokenKey);

  @override
  Future<void> deleteRefreshToken() async =>
      await store.delete(key: _refreshTokenKey);
}
