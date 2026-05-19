class PostInfo {
  final int postId;
  final String name;
  final String title;
  final List<String> skills;
  final int bookmarks;
  final int favorites;
  final DateTime createAt;
  final bool isFavorite;
  final bool isBookmark;

  PostInfo({
    required this.postId,
    required this.name,
    required this.title,
    required this.skills,
    required this.bookmarks,
    required this.favorites,
    required this.createAt,
    required this.isFavorite,
    required this.isBookmark,
  });

  PostInfo copyWith({
    int? favorites,
    bool? isFavorite,
  }) {
    return PostInfo(
      postId: postId,
      name: name,
      title: title,
      skills: skills,
      bookmarks: bookmarks,
      favorites: favorites ?? this.favorites,
      createAt: createAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmark: isBookmark,
    );
  }
}