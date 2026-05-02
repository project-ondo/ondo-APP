import 'package:ondo/data/datasource/post/post_remote_datasource.dart';
import '../../models/post/response/post_detail_model.dart';
import '../../../domain/repositories/post/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource _remoteDatasource;
  PostRepositoryImpl(this._remoteDatasource);

  @override
  Future<PostDetailModel> getPostDetail(int postId) {
    return _remoteDatasource.getPostDetail(postId);
  }
}