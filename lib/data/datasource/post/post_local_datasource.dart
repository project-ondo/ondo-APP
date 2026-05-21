import 'package:shared_preferences/shared_preferences.dart';

class PostLocalDatasource {
  static const String _likedPostsKey = 'liked_post_ids';

  SharedPreferences? _prefs;

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

    await prefs.setStringList(
      _likedPostsKey,
      likedIds.map((id) => id.toString()).toList(),
    );
  }

  Future<Set<int>> getLikedPostIds() async {
    final prefs = await _getPrefs();
    final ids = prefs.getStringList(_likedPostsKey);
    return ids?.map((id) => int.parse(id)).toSet() ?? {};
  }
}
