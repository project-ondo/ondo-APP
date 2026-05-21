class PageableWrapper<T> {
  final List<T> pages;
  final int? nextCursor;
  final bool hasNext;

  PageableWrapper({
    required this.pages,
    required this.nextCursor,
    this.hasNext = false,
  });
}
