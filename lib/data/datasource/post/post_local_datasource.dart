import 'package:shared_preferences/shared_preferences.dart';

class PostLocalDatasource {
  static const String _likedPostsKey = 'liked_post_ids';
  static const String _bookmarkedPostsKey = 'bookmarked_post_ids';

  SharedPreferences? _prefs;
  Set<int>? _cachedLikedIds;
  Set<int>? _cachedBookmarkedIds;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveLikeState(int postId, bool isLiked) async {
    final prefs = await _getPrefs();
    final likedIds = await getLikedPostIds();

    if (isLiked) {
      likedIds.add(postId);
    } else {
      likedIds.remove(postId);
    }

    _cachedLikedIds = likedIds;

    await prefs.setStringList(
      _likedPostsKey,
      likedIds.map((id) => id.toString()).toList(),
    );
  }

  Future<Set<int>> getLikedPostIds() async {
    if (_cachedLikedIds != null) return _cachedLikedIds!;

    final prefs = await _getPrefs();
    final ids = prefs.getStringList(_likedPostsKey);
    _cachedLikedIds =
        (ids ?? []).map((id) => int.tryParse(id)).whereType<int>().toSet();
    return _cachedLikedIds!;
  }

  Future<bool> likedPost(int postId) async {
    final ids = await getLikedPostIds();
    return ids.contains(postId);
  }

  Future<void> saveBookmarkState(int postId, bool isBookmarked) async {
    final prefs = await _getPrefs();
    final bookmarkedIds = await getBookmarkedPostIds();

    if (isBookmarked) {
      bookmarkedIds.add(postId);
    } else {
      bookmarkedIds.remove(postId);
    }

    _cachedBookmarkedIds = bookmarkedIds;

    await prefs.setStringList(
      _bookmarkedPostsKey,
      bookmarkedIds.map((id) => id.toString()).toList(),
    );
  }

  Future<Set<int>> getBookmarkedPostIds() async {
    if (_cachedBookmarkedIds != null) return _cachedBookmarkedIds!;

    final prefs = await _getPrefs();
    final ids = prefs.getStringList(_bookmarkedPostsKey);
    _cachedBookmarkedIds =
        (ids ?? []).map((id) => int.tryParse(id)).whereType<int>().toSet();
    return _cachedBookmarkedIds!;
  }

  Future<bool> bookmarkedPost(int postId) async {
    final ids = await getBookmarkedPostIds();
    return ids.contains(postId);
  }
}