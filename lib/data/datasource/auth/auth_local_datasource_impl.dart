import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final FlutterSecureStorage store = FlutterSecureStorage();

  //TODO : 환경 변수 설정
  static const String _accessTokenKey = "ACCESS_TOKEN";
  static const String _refreshTokenKey = "REFRESH_TOKEN";

  @override
  Future<String?> getAccessToken() async =>
      await store.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() async =>
      await store.read(key: _refreshTokenKey);

  @override
  Future<void> saveToken(String refreshToken, String accessToken) async {
    await store.write(key: _refreshTokenKey, value: refreshToken);
    await store.write(key: _accessTokenKey, value: accessToken);
  }

  @override
  Future<void> deleteAll() async => await store.deleteAll();

  Future<void> deleteAccessToken() async =>
      await store.delete(key: _accessTokenKey);

  Future<void> deleteRefreshToken() async =>
      await store.delete(key: _refreshTokenKey);
}
