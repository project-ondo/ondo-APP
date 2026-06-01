class PostDetailModel {
  final int postId;
  final String title;
  final String content;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int bookmarkCount;
  final String createdAt;
  final bool isFavorite;

  const PostDetailModel({
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
    required this.isFavorite,
  });

  factory PostDetailModel.fromJson(Map json) {
    return PostDetailModel(
      postId: json["postId"] as int,
      title: json["title"] as String,
      content: json["content"] as String,
      authorName: json["authorName"] as String,
      tags: (json["tags"] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      viewCount: json["viewCount"] as int,
      likeCount: json["likeCount"] as int,
      commentCount: json["commentCount"] as int,
      bookmarkCount: json["bookmarkCount"] as int,
      createdAt: json["createdAt"] as String,
      isFavorite: json["isFavorite"] as bool? ?? false,
    );
  }

  PostDetailModel copyWith({
    int? likeCount,
    int? commentCount,
    int? bookmarkCount,
    bool? isFavorite,
  }) {
    return PostDetailModel(
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}