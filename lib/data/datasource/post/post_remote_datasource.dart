import 'dart:convert';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/post/request/post_create_request_model.dart';
import 'package:ondo/data/models/post/request/post_search_request_model.dart';
import 'package:ondo/data/models/post/request/post_update_request_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class PostRemoteDatasource {
  final AuthClient _client;

  PostRemoteDatasource(this._client);

  Future<List> getRecentPopularPostList() async {
    final log = ApiConstants(logName: "인기 게시글 Top 10 조회 서버");
    try {
      final res = await _client.get(Uri.parse("${ApiConstants.post}/popular"));
      final body = jsonDecode(res.body);
      log.statusLog(res.statusCode);
      log.successLog(body["success"] ?? false);
      log.messageLog(body["message"]);
      if (body["success"] != true) {
        throw Exception(body["message"]);
      }
      return body["data"] as List? ?? [];
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<Map> getRecommendPostList(ListRequestModelBasePage model) async {
    final log = ApiConstants(logName: '추천 게시물 조회');
    try {
      final uri = Uri.parse(
        '${ApiConstants.post}/recommend${model.toQueryParameter()}',
      );
      final response = await _client.get(uri);
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        throw Exception(body['message']);
      }
      return body["data"];
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<Map> getPostDetail(int postId) async {
    final log = ApiConstants(logName: '게시물 상세 조회');
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.post}/$postId'),
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      return body["data"];
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<int> createPost(PostCreateRequestModel model) async {
    final log = ApiConstants(logName: '게시물 생성');
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.post),
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

  Future<void> updatePost(int postId, PostUpdateRequestModel model) async {
    final log = ApiConstants(logName: '게시물 수정');
    try {
      final response = await _client.patch(
        Uri.parse('${ApiConstants.post}/$postId'),
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

  Future<void> deletePost(int postId) async {
    final log = ApiConstants(logName: '게시물 삭제');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.post}/$postId'),
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

  Future<void> likePost(int postId) async {
    final log = ApiConstants(logName: '게시물 좋아요');
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.post}/$postId/like'),
        headers: ApiConstants.baseHeader,
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        final message = (body['message'] as String?) ?? '';
        // 이미 좋아요 상태 = 원하는 상태와 동일 → 성공으로 처리
        if (message.contains('이미 좋아요')) return;
        throw Exception(message);
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<void> unlikePost(int postId) async {
    final log = ApiConstants(logName: '게시물 좋아요 취소');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.post}/$postId/like'),
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        final message = (body['message'] as String?) ?? '';
        // 이미 좋아요 취소 상태 = 원하는 상태와 동일 → 성공으로 처리
        if (message.contains('좋아요하지 않')) return;
        throw Exception(message);
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<void> bookmarkPost(int postId) async {
    final log = ApiConstants(logName: '게시물 북마크 추가');
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.post}/$postId/bookmark'),
        headers: ApiConstants.baseHeader,
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        final message = (body['message'] as String?) ?? '';
        if (message.contains('이미 북마크')) return;
        throw Exception(message);
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<void> unbookmarkPost(int postId) async {
    final log = ApiConstants(logName: '게시물 북마크 해제');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.post}/$postId/bookmark'),
      );
      final body = jsonDecode(response.body);
      log.statusLog(response.statusCode);
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);
      if (body['success'] != true) {
        final message = (body['message'] as String?) ?? '';
        if (message.contains('북마크하지 않')) return;
        throw Exception(message);
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  Future<Map?> search(PostSearchRequestModel model) async {
    final log = ApiConstants(logName: "게시글 검색 서버");

    try {
      final res = await _client.get(
        Uri.parse(
          "${ApiConstants.post}/search${model.toQueryParameter()}",
        ),
      );

      final body = jsonDecode(res.body);

      log.successLog(body["success"]);
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
}
