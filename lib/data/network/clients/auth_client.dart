import 'dart:developer';
import 'package:http/http.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/models/auth/response/sign_in_response_model.dart';

class AuthClient extends BaseClient {
  AuthLocalDatasource localDatasource;
  AuthRemoteDatasource remoteDatasource;

  AuthClient({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await _getValidAccessToken();
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }
    return request.send();
  }

  /// 유효한 accessToken 반환
  /// 만료됐을 경우 refresh 시도 후 새 토큰 반환
  Future<String?> _getValidAccessToken() async {
    final token = await localDatasource.getAccessToken();
    if (token == null) return null;

    final expirationStr = await localDatasource.getAccessTokenExpiration();
    if (expirationStr == null) return token;

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null) return token;

    // 유효기간이 남아있으면 그대로 사용
    if (DateTime.now().isBefore(expiration)) return token;

    log("AccessToken 만료 → refresh 시도");
    return await _tryRefresh();
  }

  /// refreshToken 유효성 검사 후 새 accessToken 발급
  Future<String?> _tryRefresh() async {
    final refreshToken = await localDatasource.getRefreshToken();
    if (refreshToken == null) return null;

    // refreshToken 만료 여부 사전 확인
    final refreshExpirationStr = await localDatasource.getRefreshTokenExpiration();
    if (refreshExpirationStr != null) {
      final refreshExpiration = DateTime.tryParse(refreshExpirationStr);
      if (refreshExpiration != null && DateTime.now().isAfter(refreshExpiration)) {
        log("RefreshToken 만료 → 토큰 삭제");
        await localDatasource.deleteAll();
        return null;
      }
    }

    final json = await remoteDatasource.refreshToken(refreshToken);
    if (json != null) {
      final newToken = SignInResponseModel.fromJson(json);
      await localDatasource.saveToken(
        accessToken: newToken.accessToken,
        accessTokenExpiration: newToken.accessTokenExpiration,
        refreshToken: newToken.refreshToken,
        refreshTokenExpiration: newToken.refreshTokenExpiration,
      );
      log("토큰 재발급 성공");
      return newToken.accessToken;
    }

    log("토큰 재발급 실패 → 토큰 삭제");
    await localDatasource.deleteAll();
    return null;
  }
}
