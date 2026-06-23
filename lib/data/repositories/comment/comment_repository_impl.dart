import 'package:ondo/data/datasource/comment/comment_remote_datasource.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ListableWrapper<CommentModel>> getComments(int postId, {int page = 0, int size = 10}) async {
    try {
      return await remoteDataSource.getComments(postId, page: page, size: size);
    } catch (e) {
      throw Exception('댓글 조회 실패: $e');
    }
  }

  @override
  Future<bool> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      return await remoteDataSource.createComment(
        postId: postId,
        content: content,
      );
    } catch (e) {
      throw Exception('댓글 작성 실패: $e');
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
    } catch (e) {
      throw Exception('댓글 삭제 실패: $e');
    }
  }
}