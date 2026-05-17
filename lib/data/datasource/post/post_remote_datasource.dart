import 'dart:convert';
import 'package:ondo/data/models/post/request/post_create_request_model.dart';
import 'package:ondo/data/models/post/request/post_update_request_model.dart';
import 'package:ondo/data/models/post/response/post_list_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/models/post/response/post_detail_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

abstract class PostRemoteDatasource {
  Future<PostListModel> getRecommendPosts({int page = 0});
  Future<PostDetailModel> getPostDetail(int postId);
  Future<int> createPost(PostCreateRequestModel model);
  Future<void> updatePost(int postId, PostUpdateRequestModel model);
  Future<void> deletePost(int postId);
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final AuthClient _client;
  PostRemoteDatasourceImpl(this._client);

  @override
  Future<PostListModel> getRecommendPosts({int page = 0}) async {
    final log = ApiConstants(logName: '추천 게시물 조회');
    try {
      final uri = Uri.parse(
        '${ApiConstants.posts}/recommend',
      ).replace(queryParameters: {'page': '$page'});
      final response = await _client.get(uri);
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        throw Exception(body['message']);
      }
      return PostListModel.fromJson(body);
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

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
  Future<int> createPost(PostCreateRequestModel model) async {
    final log = ApiConstants(logName: '게시물 생성');
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.posts),
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
      return body['data'] as int;
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

  @override
  Future<void> deletePost(int postId) async {
    final log = ApiConstants(logName: '게시물 삭제');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.posts}/$postId'),
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

  @override
  Future<void> likePost(int postId) async {
    final log = ApiConstants(logName: '게시물 좋아요');
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.posts}/$postId/like'),
        headers: ApiConstants.baseHeader,
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

  @override
  Future<void> unlikePost(int postId) async {
    final log = ApiConstants(logName: '게시물 좋아요 취소');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.posts}/$postId/like'),
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