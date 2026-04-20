import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/data/models/auth/request/email_send_request_model.dart';
import 'package:ondo/data/models/auth/request/email_verify_request_model.dart';
import 'package:ondo/data/models/auth/request/sign_in_request_model.dart';
import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/email_verify_response_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class AuthRemoteDatasource {
  final String baseUrl;

  AuthRemoteDatasource(this.baseUrl);

  Future<void> sendEmailCode(String email) async {
    final log = ApiConstants(logName: '이메일 인증코드 발송');
    final model = EmailSendRequestModel(email: email);
    final url = Uri.parse('$baseUrl/auth/email/send');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    log.statusLog(response.statusCode);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      try {
        final body = jsonDecode(response.body);
        log.successLog(body['success'] ?? false);
        log.messageLog(body['message'] ?? '');
        throw Exception(body['message'] ?? AppStrings.emailSendFail);
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception(AppStrings.emailSendFail);
      }
    }

    final body = jsonDecode(response.body);
    log.successLog(body['success'] ?? true);
    log.messageLog(body['message'] ?? '');
  }

  Future<String> verifyEmailCode(String email, String code) async {
    final model = EmailVerifyRequestModel(email: email, code: code);
    final url = Uri.parse('$baseUrl/auth/email/verify');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(AppStrings.emailVerifyFail);
    }

    final responseModel = EmailVerifyResponseModel.fromJson(
      jsonDecode(response.body),
    );

    if (!responseModel.success) {
      throw Exception(responseModel.message);
    }

    final token = responseModel.data.verificationToken;

    if (token.isEmpty) {
      throw Exception(AppStrings.verificationTokenEmpty);
    }

    return token;
  }

  Future<SignupResponseModel> signup(SignupRequestModel model) async {
    final log = ApiConstants(logName: '회원가입');
    final url = Uri.parse('$baseUrl/auth/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    log.statusLog(response.statusCode);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      try {
        final body = jsonDecode(response.body);
        log.successLog(body['success'] ?? false);
        log.messageLog(body['message'] ?? '');
        throw Exception(body['message'] ?? AppStrings.signupFail);
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception(AppStrings.signupFail);
      }
    }

    final responseModel = SignupResponseModel.fromJson(
      jsonDecode(response.body),
    );

    log.successLog(responseModel.success);
    log.messageLog(responseModel.message);

    if (!responseModel.success) {
      throw Exception(responseModel.message);
    }

    return responseModel;
  }

  Future<Map?> signIn(SignInRequestModel model) async {
    final log = ApiConstants(logName: '로그인');

    try {
      final res = await http.post(
        Uri.parse('${ApiConstants.auth}/signin'),
        headers: ApiConstants.baseHeader,
        body: jsonEncode(model.toJson()),
      );
      final body = jsonDecode(res.body);

      log.successLog(body['success']);
      log.messageLog(body['message']);

      if (res.statusCode == 200 && body['success'] == true) {
        return body['data'];
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }
    return null;
  }

  Future<Map?> refreshToken(String refreshToken) async {
    final log = ApiConstants(logName: '토큰 갱신');

    try {
      final res = await http.post(
        Uri.parse('${ApiConstants.auth}/refresh'),
        headers: ApiConstants.baseHeader,
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final body = jsonDecode(res.body);

      log.successLog(body['success']);
      log.messageLog(body['message']);

      if (res.statusCode == 200 && body['success'] == true) {
        return body['data'];
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }
    return null;
  }

  /// 로그아웃 POST /auth/logout
  Future<void> logout(String refreshToken) async {
    final log = ApiConstants(logName: '로그아웃');

    try {
      final res = await http.post(
        Uri.parse('${ApiConstants.auth}/logout'),
        headers: ApiConstants.baseHeader,
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final body = jsonDecode(res.body);
      log.statusLog(res.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');
    } catch (e) {
      log.errorLog(e);
    }
  }
}