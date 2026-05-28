import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalDataSource {
  late final SharedPreferences? _prefs;

  final String _searchKeywordListKey = 'SEARCH_KEYWORD_LIST_KEY';

  final List<String> _cacheSearchKeywordList = [];

  Future<SharedPreferences> getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveSearchKeyword(String keyword) async {
    _cacheSearchKeywordList.assignAll([
      keyword,
      ..._cacheSearchKeywordList.take(2),
    ]);
    return await (await getPrefs()).setStringList(
      _searchKeywordListKey,
      _cacheSearchKeywordList,
    );
  }

  Future<List<String>> getSearchKeywordList() async {
    if (_cacheSearchKeywordList.isEmpty) {
      _cacheSearchKeywordList.assignAll(
        (await getPrefs()).getStringList(_searchKeywordListKey) ?? [],
      );
    }
    return _cacheSearchKeywordList.take(3).toList();
  }
}
