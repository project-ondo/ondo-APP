import 'dart:convert';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/models/post/response/post_detail_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

abstract class PostRemoteDatasource {
  Future<PostDetailModel> getPostDetail(int postId);
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
}