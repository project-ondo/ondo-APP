import 'package:ondo/data/datasource/post/post_local_datasource.dart';

class SavePostLikeLocalUseCase {
  final PostLocalDatasource _datasource;

  SavePostLikeLocalUseCase({required PostLocalDatasource datasource})
      : _datasource = datasource;

  Future<void> call(int postId, bool isLiked) {
    return _datasource.saveLikeState(postId, isLiked);
  }
}
