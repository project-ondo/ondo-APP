import '../../../data/models/post/response/post_detail_model.dart';

abstract class PostRepository {
  Future<PostDetailModel> getPostDetail(int postId);
}