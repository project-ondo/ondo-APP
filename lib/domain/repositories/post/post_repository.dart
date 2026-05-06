import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../data/models/post/response/post_detail_model.dart';

abstract class PostRepository {
  Future<PostDetailModel> getPostDetail(int postId);
  Future<void> updatePost(int postId, PostUpdateRequestModel model);
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
}