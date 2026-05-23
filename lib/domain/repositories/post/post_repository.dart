import '../../../data/models/post/request/post_create_request_model.dart';
import '../../../data/models/post/request/post_update_request_model.dart';
import '../../../data/models/post/response/post_detail_model.dart';
import '../../../data/models/post/response/post_list_model.dart';

abstract class PostRepository {
  Future<PostListModel> getRecommendPosts({int page = 0});
  Future<PostDetailModel> getPostDetail(int postId);
  Future<int> createPost(PostCreateRequestModel model);
  Future<void> updatePost(int postId, PostUpdateRequestModel model);
  Future<void> deletePost(int postId);
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);

  /// 로컬 좋아요 캐시
  Future<Set<int>> getCachedLikedPostIds();
  Future<void> saveLikeState(int postId, bool isLiked);
}