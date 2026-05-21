import '../../../domain/repositories/post/post_repository.dart';
import '../../datasource/post/post_remote_datasource.dart';
import '../../models/post/request/post_create_request_model.dart';
import '../../models/post/request/post_update_request_model.dart';
import '../../models/post/response/post_detail_model.dart';
import '../../models/post/response/post_list_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource _remoteDatasource;
  PostRepositoryImpl(this._remoteDatasource);

  @override
  Future<PostListModel> getRecommendPosts({int page = 0}) {
    return _remoteDatasource.getRecommendPosts(page: page);
  }

  @override
  Future<PostDetailModel> getPostDetail(int postId) {
    return _remoteDatasource.getPostDetail(postId);
  }

  @override
  Future<int> createPost(PostCreateRequestModel model) {
    return _remoteDatasource.createPost(model);
  }

  @override
  Future<void> updatePost(int postId, PostUpdateRequestModel model) {
    return _remoteDatasource.updatePost(postId, model);
  }

  @override
  Future<void> deletePost(int postId) {
    return _remoteDatasource.deletePost(postId);
  }

  @override
  Future<void> likePost(int postId) {
    return _remoteDatasource.likePost(postId);
  }

  @override
  Future<void> unlikePost(int postId) {
    return _remoteDatasource.unlikePost(postId);
  }
}