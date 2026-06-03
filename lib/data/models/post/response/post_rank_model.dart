import 'package:ondo/data/models/post/response/post_model.dart';

class PostRankModel extends PostModel {
  final int rank;

  PostRankModel({
    required this.rank,
    required super.postId,
    required super.title,
    required super.authorName,
    required super.tags,
    required super.viewCount,
    required super.likeCount,
    required super.commentCount,
    required super.createdAt,
    required super.bookmarkCount,
  });

  PostRankModel.fromJson(super.json)
    : rank = json["rank"] as int,
      super.fromJson();
}
