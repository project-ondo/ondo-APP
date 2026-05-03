import 'dart:convert';
import 'package:ondo/data/models/post/request/post_update_request_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/models/post/response/post_detail_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

abstract class PostRemoteDatasource {
  Future<PostDetailModel> getPostDetail(int postId);
  Future<void> updatePost(int postId, PostUpdateRequestModel model);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final AuthClient _client;
  PostRemoteDatasourceImpl(this._client);

  @override
  Future<PostDetailModel> getPostDetail(int postId) async {
    final log = ApiConstants(logName: '게시물 상세 조회');
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.posts}/$postId'),
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      return PostDetailModel.fromJson(body);
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  @override
  Future<void> updatePost(int postId, PostUpdateRequestModel model) async {
    final log = ApiConstants(logName: '게시물 수정');
    try {
      final response = await _client.patch(
        Uri.parse('${ApiConstants.posts}/$postId'),
        headers: ApiConstants.baseHeader,
        body: jsonEncode(model.toJson()),
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        throw Exception(body['message']);
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }
}