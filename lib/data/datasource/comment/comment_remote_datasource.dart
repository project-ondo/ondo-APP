import 'dart:convert';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments(int postId);
  Future<bool> createComment({
    required int postId,
    required String content,
  });
  Future<void> deleteComment(int commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final AuthClient _client;
  CommentRemoteDataSourceImpl(this._client);

  Map<String, dynamic> _parseBody(String responseBody, String logName) {
    if (responseBody.isEmpty) {
      throw Exception('[$logName] 응답 바디가 비어있습니다.');
    }
    try {
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('[$logName] JSON 파싱 실패: $e');
    }
  }

  @override
  Future<List<CommentModel>> getComments(int postId) async {
    final log = ApiConstants(logName: '댓글 조회');
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.comment}/$postId'),
      );
      log.statusLog(response.statusCode);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('댓글 조회 실패 (${response.statusCode})');
      }

      final body = _parseBody(response.body, '댓글 조회');
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);

      if (body['success'] != true) {
        throw Exception(body['message']);
      }

      final data = body['data'];
      if (data == null) return [];

      final list = (data['content'] as List?) ?? [];
      return list.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  @override
  Future<bool> createComment({
    required int postId,
    required String content,
  }) async {
    final log = ApiConstants(logName: '댓글 작성');
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.comment}/$postId'),
        headers: ApiConstants.baseHeader,
        body: jsonEncode({'content': content}),
      );
      log.statusLog(response.statusCode);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('댓글 작성 실패 (${response.statusCode})');
      }

      final body = _parseBody(response.body, '댓글 작성');
      log.successLog(body['success'] ?? false);
      log.messageLog(body['message']);

      if (body['success'] != true) {
        throw Exception(body['message']);
      }

      return true;
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    final log = ApiConstants(logName: '댓글 삭제');
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.comment}/$commentId'),
      );
      log.statusLog(response.statusCode);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('댓글 삭제 실패 (${response.statusCode})');
      }

      if (response.body.isNotEmpty) {
        final body = _parseBody(response.body, '댓글 삭제');
        log.successLog(body['success'] ?? false);
        log.messageLog(body['message']);

        if (body['success'] != true) {
          throw Exception(body['message']);
        }
      }
    } catch (e) {
      log.errorLog(e);
      rethrow;
    }
  }
}