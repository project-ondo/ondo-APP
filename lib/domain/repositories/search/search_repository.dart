abstract class SearchRepository {
  Future<List<String>> getSearchKeywordList();

  Future<bool> saveSearchKeyword(String keyword);
}
