class BookmarkChangedEvent {
  final int postId;
  final bool isBookmarked;
  final int bookmarkCount;

  BookmarkChangedEvent({
    required this.postId,
    required this.isBookmarked,
    required this.bookmarkCount,
  });
}
