import 'package:ondo/data/models/post/response/post_detail_model.dart';

class PostDetailEntity {
  final int postId;
  final String title;
  final String content;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int bookmarkCount;
  final DateTime createdAt;
  final bool isLike;
  final bool isBookmark;

  const PostDetailEntity({
    required this.postId,
    required this.title,
    required this.content,
    required this.authorName,
    required this.tags,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.createdAt,
    this.isLike = false,
    this.isBookmark = false,
  });

  factory PostDetailEntity.fromPostDetailModel(PostDetailModel model) =>
      PostDetailEntity(
        postId: model.postId,
        title: model.title,
        content: model.content,
        authorName: model.authorName,
        tags: model.tags,
        viewCount: model.viewCount,
        likeCount: model.likeCount,
        commentCount: model.commentCount,
        bookmarkCount: model.bookmarkCount,
        createdAt: DateTime.tryParse(model.createdAt) ?? DateTime.now(),
        isLike: model.isFavorite,
      );

  bool get isFavorite => isLike;

  PostDetailEntity copyWith({
    int? likeCount,
    int? commentCount,
    int? bookmarkCount,
    bool? isFavorite,
    bool? isLike,
    bool? isBookmark,
  }) => PostDetailEntity(
    postId: postId,
    title: title,
    content: content,
    authorName: authorName,
    tags: tags,
    viewCount: viewCount,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount ?? this.commentCount,
    bookmarkCount: bookmarkCount ?? this.bookmarkCount,
    createdAt: createdAt,
    isLike: isLike ?? isFavorite ?? this.isLike,
    isBookmark: isBookmark ?? this.isBookmark,
  );
}
