import 'dart:convert';

import 'package:ondo/data/models/user/request/update_profile_request_model.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class ProfileRemoteDatasource {
  final AuthClient client;

  ProfileRemoteDatasource({required this.client});

  /// 내 프로필 조회 GET /users/my/profile
  Future<UserProfileDataModel> getMyProfile() async {
    final log = ApiConstants(logName: '내 프로필 조회');

    final res = await client.get(
      Uri.parse('${ApiConstants.users}/my/profile'),
    );

    log.statusLog(res.statusCode);

    try {
      final body = jsonDecode(res.body);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');

      if (res.statusCode != 200 || body['success'] != true) {
        throw Exception(body['message'] ?? '내 프로필 조회 실패');
      }

    final responseModel = UserProfileResponseModel.fromJson(body);

    if (responseModel.data == null) {
      throw Exception('프로필 데이터가 없습니다.');
    }

      return responseModel.data!;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('내 프로필 조회 중 오류가 발생했습니다.');
    }
  }

  /// 내 프로필 수정 PATCH /users/my/profile
  Future<void> updateProfile(UpdateProfileRequestModel model) async {
    final log = ApiConstants(logName: '프로필 수정');

    final res = await client.patch(
      Uri.parse('${ApiConstants.users}/my/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    log.statusLog(res.statusCode);

    try {
      final body = jsonDecode(res.body);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');

      if (res.statusCode != 200 || body['success'] != true) {
        throw Exception(body['message'] ?? '프로필 수정 실패');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('프로필 수정 중 오류가 발생했습니다.');
    }
  }

  /// 프로필 이미지 키 변경 PUT /users/my/profile/image
  Future<void> updateProfileImage(String imageKey) async {
    final log = ApiConstants(logName: '프로필 이미지 변경');

    final res = await client.put(
      Uri.parse('${ApiConstants.users}/my/profile/image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'key': imageKey}),
    );

    log.statusLog(res.statusCode);

    try {
      final body = jsonDecode(res.body);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');

      if (res.statusCode != 200 || body['success'] != true) {
        throw Exception(body['message'] ?? '프로필 이미지 변경 실패');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('프로필 이미지 변경 중 오류가 발생했습니다.');
    }
  }

  /// 회원탈퇴 DELETE /users/my
  Future<void> deleteAccount() async {
    final log = ApiConstants(logName: '회원탈퇴');

    final res = await client.delete(
      Uri.parse('${ApiConstants.users}/my'),
    );

    log.statusLog(res.statusCode);

    try {
      final body = jsonDecode(res.body);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');

      if (res.statusCode != 200 || body['success'] != true) {
        throw Exception(body['message'] ?? '회원탈퇴 실패');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('회원탈퇴 중 오류가 발생했습니다.');
    }
  }
}