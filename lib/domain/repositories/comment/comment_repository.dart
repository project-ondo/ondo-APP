import 'package:ondo/data/models/comment/response/comment_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';

abstract class CommentRepository {
  Future<ListableWrapper<CommentModel>> getComments(int postId, {int page = 0, int size = 10});

  Future<bool> createComment({
    required int postId,
    required String content,
  });

  Future<void> deleteComment(int commentId);
}