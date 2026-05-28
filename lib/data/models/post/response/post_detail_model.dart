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
  });

  factory PostDetailModel.fromJson(Map json) {
    return PostDetailModel(
      postId: json["postId"] as int,
      title: json["title"] as String,
      content: json["content"] as String,
      authorName: json["authorName"] as String,
      tags:
          (json["tags"] as List?)
              ?.map(
                (e) => e.toString(),
              )
              .toList() ??
          [],
      viewCount: json["viewCount"] as int,
      likeCount: json["likeCount"] as int,
      commentCount: json["commentCount"] as int,
      bookmarkCount: json["bookmarkCount"] as int,
      createdAt: json["createdAt"] as String,
    );
  }
}
