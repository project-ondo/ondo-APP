class PageableWrapper<T> {
  final List<T> pages;
  final int? nextCursor;

  PageableWrapper({required this.pages, required this.nextCursor});
}
