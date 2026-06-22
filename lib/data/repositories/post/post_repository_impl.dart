import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/post/request/post_search_request_model.dart';
import 'package:ondo/data/models/post/response/post_model.dart';
import 'package:ondo/data/models/post/response/post_rank_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/post/post_detail_entity.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/post/post_rank_entity.dart';

import '../../../domain/repositories/post/post_repository.dart';
import '../../datasource/post/post_local_datasource.dart';
import '../../datasource/post/post_remote_datasource.dart';
import '../../models/post/request/post_create_request_model.dart';
import '../../models/post/request/post_update_request_model.dart';
import '../../models/post/response/post_detail_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource _remoteDatasource;
  final PostLocalDatasource _localDatasource;

  PostRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<PostRankEntity>> loadRecentPopularPostList() async {
    final json = await _remoteDatasource.getRecentPopularPostList();
    final data = json.map((e) => PostRankModel.fromJson(e)).toList();
    return data.map((e) => PostRankEntity.fromPostRankModel(e)).toList();
  }

  @override
  Future<ListableWrapper<PostEntity>> loadRecommendPostList(
      int page,
      int size,
      ) async {
    final model = ListRequestModelBasePage(size: size, page: page);
    final json = await _remoteDatasource.getRecommendPostList(model);
    final data = PostDataModel.fromJson(json);

    return ListableWrapper(
      page: data.page,
      size: data.size,
      totalElements: data.totalElements,
      totalPages: data.totalPages,
      last: data.last,
      content: data.content.map((e) => PostEntity.fromPostModel(e)).toList(),
    );
  }

  @override
  Future<PostDetailEntity> loadPostDetail(int postId) async {
    final json = await _remoteDatasource.getPostDetail(postId);
    final model = PostDetailModel.fromJson(json);
    return PostDetailEntity.fromPostDetailModel(model);
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

  @override
  Future<void> bookmarkPost(int postId) {
    return _remoteDatasource.bookmarkPost(postId);
  }

  @override
  Future<void> unbookmarkPost(int postId) {
    return _remoteDatasource.unbookmarkPost(postId);
  }

  @override
  Future<Set<int>> getCachedLikedPostIds() {
    return _localDatasource.getLikedPostIds();
  }

  @override
  Future<void> saveLikeState(int postId, bool isLiked) {
    return _localDatasource.saveLikeState(postId, isLiked);
  }

  @override
  Future<bool> likedPost(int postId) {
    return _localDatasource.likedPost(postId);
  }

  @override
  Future<ListableWrapper<PostEntity>> search(
      String keyword,
      List<String>? tags,
      String? sort,
      bool? latest,
      int? page,
      int? size,
      ) async {
    final model = PostSearchRequestModel(
      keyword: keyword,
      tags: tags,
      sort: sort,
      latest: latest,
      page: page,
      size: size,
    );
    final json = await _remoteDatasource.search(model);

    final data = PostDataModel.fromJson(json);
    return ListableWrapper<PostEntity>(
      page: data.page,
      size: data.size,
      totalElements: data.totalElements,
      totalPages: data.totalPages,
      last: data.last,
      content: data.content.map((e) => PostEntity.fromPostModel(e)).toList(),
    );
  }
}