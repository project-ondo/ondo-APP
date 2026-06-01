import 'package:ondo/data/models/post/response/post_rank_model.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';

class PostRankEntity extends PostEntity {
  final int rank;

  PostRankEntity({
    required this.rank,
    required super.postId,
    required super.title,
    required super.authorName,
    required super.tags,
    required super.viewCount,
    required super.likeCount,
    required super.commentCount,
    required super.bookmarkCount,
    required super.createAt,
  });

  PostRankEntity.fromPostRankModel(PostRankModel super.model)
    : rank = model.rank,
      super.fromPostModel();
}
