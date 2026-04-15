import 'package:ondo/data/datasource/home/home_remote_datasource.dart';
import 'package:ondo/data/models/base/request/base_list_request_model.dart';
import 'package:ondo/data/models/post/response/post_model.dart';
import 'package:ondo/data/models/user/response/user_model.dart';
import '../../../domain/repositories/home/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDatasource datasource;

  HomeRepositoryImpl({required this.datasource});

  @override
  Future<List<PostModel>> getRecommendPostList({
    required int page,
    required int size,
  }) async {
    final model = BaseListRequestModel(size: size, page: page);

    final json = await datasource.loadRecommendPostList(model);
    if (json != null) {
      final res = PostDataModel.fromJson(json);
      return res.content;
    }
    return [];
  }

  @override
  Future<List<UserModel>> getRecommendUserList({
    required int page,
    required int size,
  }) async {
    final model = BaseListRequestModel(size: size, page: page);

    final json = await datasource.loadRecommendProfileList(model);
    if (json != null) {
      final res = UserDataModel.fromJson(json);
      return res.content;
    }
    return [];
  }
}
