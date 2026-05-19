import 'package:dartz/dartz.dart';
import 'package:ondo/data/datasource/comment/comment_remote_datasource.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/repositories/comment/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CommentModel>>> getComments(int postId) async {
    try {
      final comments = await remoteDataSource.getComments(postId);
      return Right(comments);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      await remoteDataSource.createComment(postId: postId, content: content);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteComment(int commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
