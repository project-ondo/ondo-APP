import 'package:ondo/data/datasource/post/post_local_datasource.dart';

class GetCachedLikedPostIdsUseCase {
  final PostLocalDatasource _datasource;

  GetCachedLikedPostIdsUseCase({required PostLocalDatasource datasource})
      : _datasource = datasource;

  Future<Set<int>> call() {
    return _datasource.getLikedPostIds();
  }
}
