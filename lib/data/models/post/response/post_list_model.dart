class PostListModel {
  final List<PostContentModel> content;
  final int page;
  final int size;
  final int totalElement;
  final int totalPages;
  final bool last;

  PostListModel({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElement,
    required this.totalPages,
    required this.last,
  });

  factory PostListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PostListModel(
      content: (data['content'] as List)
          .map((e) => PostContentModel.fromJson(e))
          .toList(),
      page: data['page'] ?? 0,
      size: data['size'] ?? 0,
      totalElement: data['totalElement'] ?? 0,
      totalPages: data['totalPages'] ?? 0,
      last: data['last'] ?? false,
    );
  }
}

class PostContentModel {
  final int postId;
  final String title;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final bool isFavorite;

  PostContentModel({
    required this.postId,
    required this.title,
    required this.authorName,
    required this.tags,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    this.isFavorite = false,
  });

  factory PostContentModel.fromJson(Map<String, dynamic> json) {
    return PostContentModel(
      postId: json['postId'] ?? 0,
      title: json['title'] ?? '',
      authorName: json['authorName'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  PostContentModel copyWith({
    int? likeCount,
    bool? isFavorite,
  }) {
    return PostContentModel(
      postId: postId,
      title: title,
      authorName: authorName,
      tags: tags,
      viewCount: viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}