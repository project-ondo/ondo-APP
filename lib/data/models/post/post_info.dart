class PostInfo {
  final int postId;
  final String name;
  final String title;
  final List<String> skills;
  final int bookmarks;
  final int favoites;
  final DateTime createAt;
  final bool isFavorite;
  final bool isBookmark;

  PostInfo({
    required this.postId,
    required this.name,
    required this.title,
    required this.skills,
    required this.bookmarks,
    required this.favoites,
    required this.createAt,
    required this.isFavorite,
    required this.isBookmark,
  });

  PostInfo copyWith({
    int? favoites,
    bool? isFavorite,
  }) {
    return PostInfo(
      postId: postId,
      name: name,
      title: title,
      skills: skills,
      bookmarks: bookmarks,
      favoites: favoites ?? this.favoites,
      createAt: createAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmark: isBookmark,
    );
  }
}