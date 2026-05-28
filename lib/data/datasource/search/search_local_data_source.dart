import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalDataSource {
  SharedPreferences? _prefs;
  bool _isLoaded = false;

  final String _searchKeywordListKey = 'SEARCH_KEYWORD_LIST_KEY';

  final List<String> _cacheSearchKeywordList = [];

  Future<SharedPreferences> getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _ensureLoaded() async {
    if (!_isLoaded) {
      _cacheSearchKeywordList.assignAll(
        (await getPrefs()).getStringList(_searchKeywordListKey) ?? [],
      );
      _isLoaded = true;
    }
  }

  Future<bool> saveSearchKeyword(String keyword) async {
    await _ensureLoaded();
    _cacheSearchKeywordList.remove(keyword);
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
    await _ensureLoaded();
    return _cacheSearchKeywordList.take(3).toList();
  }
}
