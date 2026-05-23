class PostDetailModel {
  final int postId;
  final String title;
  final String content;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
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
    this.isFavorite = false,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception(json['message'] ?? '게시물을 찾을 수 없습니다.');
    }
    return PostDetailModel(
      postId: data['postId'] as int,
      title: data['title'] as String,
      content: data['content'] as String,
      authorName: data['authorName'] as String,
      tags: List<String>.from(data['tags']),
      viewCount: data['viewCount'] as int,
      likeCount: data['likeCount'] as int,
      commentCount: data['commentCount'] as int,
      isFavorite: data['isFavorite'] == true,
    );
  }
}