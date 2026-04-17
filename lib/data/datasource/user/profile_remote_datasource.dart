import 'dart:convert';

import 'package:ondo/data/models/user/request/update_profile_request_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class ProfileRemoteDatasource {
  final AuthClient client;

  ProfileRemoteDatasource({required this.client});

  /// 내 프로필 수정
  Future<void> updateProfile(UpdateProfileRequestModel model) async {
    final log = ApiConstants(logName: '프로필 수정');

    final res = await client.patch(
      Uri.parse('${ApiConstants.users}/me'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    final body = jsonDecode(res.body);
    log.successLog(body['success'] ?? false);
    log.messageLog(body['message'] ?? '');

    if (res.statusCode != 200 || body['success'] != true) {
      log.statusLog(res.statusCode);
      throw Exception('프로필 수정 실패: ${body['message']}');
    }
  }
}