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
    this.isFavorite = false,
  });

  PostEntity copyWith({int? likeCount, bool? isFavorite}) => PostEntity(
    postId: postId,
    title: title,
    authorName: authorName,
    tags: tags,
    viewCount: viewCount,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount,
    bookmarkCount: bookmarkCount,
    createAt: createAt,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  factory PostEntity.fromPostModel(PostModel model) => PostEntity(
    postId: model.postId,
    title: model.title,
    authorName: model.authorName,
    tags: model.tags,
    viewCount: model.viewCount,
    likeCount: model.likeCount,
    commentCount: model.commentCount,
    //TODO : 북마크 api 개발 이후, 수정
    bookmarkCount: model.likeCount,
    //TODO : 게시물 생성 시간 api 개발 이후, 수정
    createAt: DateTime.now(),
    isFavorite: model.isFavorite,
  );
}
