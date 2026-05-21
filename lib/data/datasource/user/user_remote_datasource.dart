import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/base/request/base_search_request_model.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

import '../../models/base/request/base_list_request_model.dart';

class UserRemoteDatasource {
  final BaseClient client;

  UserRemoteDatasource({required this.client});

  Future<Map?> search(BaseSearchRequestModel model) async {
    final log = ApiConstants(logName: "유저 검색");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.user}/search?${model.toQueryString()}"),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"] == true);
      log.messageLog(body["message"]);

      if (res.statusCode == 200 && body["success"] == true) {
        return body["data"];
      }
      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }

    return null;
  }

  Future<Map?> loadRecommendUserList(
    ListRequestModel model,
  ) async {
    final log = ApiConstants(logName: "홈 추천 사용자 조회");

    try {
      final res = await client.get(
        Uri.parse("${ApiConstants.user}/recommend${model.toQueryParameter()}"),
      );
      final body = jsonDecode(res.body);

      log.successLog(body["success"] == true);
      log.messageLog(body["message"]);

      if (res.statusCode == 200 && body["success"] == true) {
        return body["data"];
      }

      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }
    return null;
  }

  /// 상대 프로필 조회 GET /users/{publicId}/profile
  Future<UserProfileDataModel> getOtherProfile(String publicId) async {
    final log = ApiConstants(logName: '상대 프로필 조회');

    try {
      final res = await client.get(
        Uri.parse('${ApiConstants.user}/$publicId/profile'),
      );

      // 상태 코드 먼저 확인 후 jsonDecode
      log.statusLog(res.statusCode);

      if (res.statusCode != 200) {
        throw Exception('상대 프로필 조회 실패: ${res.statusCode}');
      }

      final body = jsonDecode(res.body);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message'] ?? '');

      if (body['success'] != true) {
        throw Exception(body['message'] ?? '상대 프로필 조회 실패');
      }

      final responseModel = UserProfileResponseModel.fromJson(body);

      if (responseModel.data == null) {
        throw Exception('프로필 데이터가 없습니다.');
      }

      return responseModel.data!;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('상대 프로필 조회 중 오류가 발생했습니다.');
    }
  }
}