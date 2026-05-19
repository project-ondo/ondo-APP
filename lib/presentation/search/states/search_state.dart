class SearchState {
  final Set<String> tags;
  final String keyword;

  SearchState({required this.tags, required this.keyword});

  SearchState.none({this.keyword = "", this.tags = const {}});

  SearchState copyWith({String? keyword, List<String>? tags}) => SearchState(
    tags: tags?.toSet() ?? this.tags,
    keyword: keyword ?? this.keyword,
  );
}
