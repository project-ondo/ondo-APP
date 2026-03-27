import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/data/models/auth/request/email_send_request_model.dart';
import 'package:ondo/data/models/auth/request/email_verify_request_model.dart';
import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/email_verify_response_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';

class AuthRemoteDatasource {
  final String baseUrl;

  AuthRemoteDatasource(this.baseUrl);

  Future<void> sendEmailCode(String email) async {
    final model = EmailSendRequestModel(email: email);

    final url = Uri.parse("$baseUrl/auth/email/send");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(AppStrings.emailSendFail);
    }
  }

  Future<String> verifyEmailCode(String email, String code) async {
    final model = EmailVerifyRequestModel(email: email, code: code);

    final url = Uri.parse("$baseUrl/auth/email/verify");

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
    final url = Uri.parse("$baseUrl/auth/signup");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (!kDebugMode) {
        debugPrint('statusCode: ${response.statusCode}');
        debugPrint('body: ${response.body}');
      }
      throw Exception('${AppStrings.signupFail}: ${response.body}');
    }

    final responseModel = SignupResponseModel.fromJson(
      jsonDecode(response.body),
    );

    if (!responseModel.success) {
      throw Exception(responseModel.message);
    }

    return responseModel;
  }
}
