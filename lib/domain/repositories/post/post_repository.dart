import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/post/post_detail_entity.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/post/post_rank_entity.dart';

import '../../../data/models/post/request/post_create_request_model.dart';
import '../../../data/models/post/request/post_update_request_model.dart';

abstract class PostRepository {
  Future<List<PostRankEntity>> loadRecentPopularPostList();

  Future<ListableWrapper<PostEntity>> loadRecommendPostList(int page, int size);

  Future<PostDetailEntity> loadPostDetail(int postId);

  Future<int> createPost(PostCreateRequestModel model);

  Future<void> updatePost(int postId, PostUpdateRequestModel model);

  Future<void> deletePost(int postId);

  Future<void> likePost(int postId);

  Future<void> unlikePost(int postId);

  Future<void> bookmarkPost(int postId);

  Future<void> unbookmarkPost(int postId);

  Future<Set<int>> getCachedLikedPostIds();

  Future<void> saveLikeState(int postId, bool isLiked);

  Future<bool> likedPost(int postId);

  Future<void> saveBookmarkState(int postId, bool isBookmarked);

  Future<bool> bookmarkedPost(int postId);

  Future<ListableWrapper<PostEntity>> search(
      String keyword,
      List<String>? tags,
      String? sort,
      bool? latest,
      int? page,
      int? size,
      );
}