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
    super.isFavorite,
    super.isBookmark,
  });

  PostRankEntity.fromPostRankModel(PostRankModel super.model)
    : rank = model.rank,
      super.fromPostModel();

  @override
  PostRankEntity copyWith({
    String? title,
    List<String>? tags,
    int? likeCount,
    int? bookmarkCount,
    bool? isFavorite,
    bool? isBookmark,
  }) => PostRankEntity(
    rank: rank,
    postId: postId,
    title: title ?? this.title,
    authorName: authorName,
    tags: tags ?? this.tags,
    viewCount: viewCount,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount,
    bookmarkCount: bookmarkCount ?? this.bookmarkCount,
    createAt: createAt,
    isFavorite: isFavorite ?? this.isFavorite,
    isBookmark: isBookmark ?? this.isBookmark,
  );
}
