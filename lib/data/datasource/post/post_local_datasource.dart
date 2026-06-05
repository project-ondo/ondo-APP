import 'package:shared_preferences/shared_preferences.dart';

class PostLocalDatasource {
  static const String _likedPostsKey = 'liked_post_ids';

  SharedPreferences? _prefs;
  Set<int>? _cachedLikedIds;

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
}