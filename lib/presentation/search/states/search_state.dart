class SearchState {
  String keyword;

  SearchState({this.keyword = ''});

  void clear() {
    keyword = '';
  }

  void setKeyword({String? query, String? tag, String? tip}) {
    keyword = query ?? tag ?? tip ?? keyword;
  }
}
