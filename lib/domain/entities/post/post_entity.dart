import 'package:ondo/data/models/post/response/post_model.dart';

class PostEntity {
  final int postId;
  final String title;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int bookmarkCount;
  final DateTime createAt;
  final bool isFavorite;
  final bool isBookmark;

  PostEntity({
    required this.postId,
    required this.title,
    required this.authorName,
    required this.tags,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.createAt,
    //TODO api에선 좋아요, 북마크를 눌렀는 지, 여부를 넘겨주지 않는다.
    this.isFavorite = false,
    this.isBookmark = false,
  });

  PostEntity copyWith({
    String? title,
    List<String>? tags,
    int? likeCount,
    int? bookmarkCount,
    bool? isFavorite,
    bool? isBookmark,
  }) => PostEntity(
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

  PostEntity.fromPostModel(PostModel model)
    : postId = model.postId,
      title = model.title,
      authorName = model.authorName,
      tags = model.tags,
      viewCount = model.viewCount,
      likeCount = model.likeCount,
      commentCount = model.commentCount,
      bookmarkCount = model.bookmarkCount,
      createAt = DateTime.tryParse(model.createdAt) ?? DateTime.now(),
      isFavorite = false,
      isBookmark = false;
}
