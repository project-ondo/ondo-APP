import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/models/auth/response/sign_in_response_model.dart';

class AuthClient extends BaseClient {
  AuthLocalDatasource localDatasource;
  AuthRemoteDatasource remoteDatasource;

  /// 인증 실패(토큰 갱신 불가) 시 호출되는 콜백 — 상위 레이어에서 로그인 화면 이동 처리
  final VoidCallback? onAuthFailed;

  /// 진행 중인 토큰 갱신 Future — _getValidAccessToken과 401 재시도 모두에서 공유하여 중복 갱신 방지
  Future<String?>? _refreshFuture;

  AuthClient({
    required this.localDatasource,
    required this.remoteDatasource,
    this.onAuthFailed,
  });

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await _getValidAccessToken();
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    final response = await request.send();

    // 서버 401 응답 시 토큰 갱신 후 재시도
    if (response.statusCode == 401) {
      log("서버 401 응답 → 토큰 갱신 후 재시도");
      // 동시 401 응답 시 갱신 Future 공유하여 중복 갱신 방지
      _refreshFuture ??= _tryRefresh().whenComplete(() => _refreshFuture = null);
      final newToken = await _refreshFuture;
      if (newToken == null) {
        log("토큰 갱신 실패 → 원래 401 응답 반환");
        return response;
      }

      final retryRequest = _cloneRequest(request, newToken);
      if (retryRequest == null) return response;

      log("재시도 요청 전송");
      return retryRequest.send();
    }

    return response;
  }

  /// BaseRequest를 새 토큰으로 복제
  BaseRequest? _cloneRequest(BaseRequest original, String newToken) {
    try {
      if (original is Request) {
        final cloned = Request(original.method, original.url);
        cloned.headers.addAll(original.headers);
        cloned.headers.remove('content-length');
        cloned.headers["Authorization"] = "Bearer $newToken";
        cloned.bodyBytes = original.bodyBytes;
        cloned.encoding = original.encoding;
        return cloned;
      }
      if (original is MultipartRequest) {
        // MultipartFile은 ByteStream을 일회성으로 사용하므로 재전송 불가
        log("MultipartRequest는 파일 스트림 재사용이 불가능하여 재시도를 지원하지 않습니다.");
        return null;
      }
      log("지원하지 않는 요청 타입: ${original.runtimeType}");
      return null;
    } catch (e) {
      log("요청 복제 실패: $e");
      return null;
    }
  }

  /// 유효한 accessToken 반환
  /// 만료됐을 경우 refresh 시도 후 새 토큰 반환
  Future<String?> _getValidAccessToken() async {
    final token = await localDatasource.getAccessToken();
    if (token == null) return null;

    final expirationStr = await localDatasource.getAccessTokenExpiration();
    if (expirationStr == null) return token;

    final expiration = AppDateUtils.tryParseUtc(expirationStr);
    if (expiration == null) return token;

    // 유효기간이 남아있으면 그대로 사용
    if (DateTime.now().isBefore(expiration)) return token;

    log("AccessToken 만료 → refresh 시도");
    _refreshFuture ??= _tryRefresh().whenComplete(() => _refreshFuture = null);
    return await _refreshFuture;
  }

  /// refreshToken 유효성 검사 후 새 accessToken 발급
  /// 갱신 완전 실패 시 로그인 화면으로 이동
  Future<String?> _tryRefresh() async {
    final refreshToken = await localDatasource.getRefreshToken();
    if (refreshToken == null) {
      log("RefreshToken 없음 → 로그인 화면 이동");
      _navigateToLogin();
      return null;
    }

    // refreshToken 만료 여부 사전 확인
    final refreshExpirationStr = await localDatasource.getRefreshTokenExpiration();
    if (refreshExpirationStr != null) {
      final refreshExpiration = AppDateUtils.tryParseUtc(refreshExpirationStr);
      if (refreshExpiration != null && DateTime.now().isAfter(refreshExpiration)) {
        log("RefreshToken 만료 → 토큰 삭제 후 로그인 화면 이동");
        await localDatasource.deleteAll();
        _navigateToLogin();
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

    log("토큰 재발급 실패 → 토큰 삭제 후 로그인 화면 이동");
    await localDatasource.deleteAll();
    _navigateToLogin();
    return null;
  }

  /// 인증 실패 콜백 호출 — 상위 레이어에서 로그인 화면 이동 등을 처리
  void _navigateToLogin() {
    try {
      onAuthFailed?.call();
    } catch (e) {
      log("인증 실패 콜백 실행 오류: $e");
    }
  }
}
