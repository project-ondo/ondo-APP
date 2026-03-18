import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ondo/data/models/auth/request/email_send_request_model.dartt';

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

    if (response.statusCode != 200 || response.statusCode >= 300) {
      throw Exception("이메일 인증 코드 전송 실패");
    }
  }
}
