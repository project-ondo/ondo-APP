import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/models/base/request/base_search_request_model.dart';
import 'package:ondo/data/models/user/response/user_model.dart';
import 'package:ondo/domain/repositories/user/user_repository.dart';

import '../../models/base/request/base_list_request_model.dart';

class UserRepositoryImpl extends UserRepository {
  UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<UserModel>> search({
    String? keyword,
    String? major,
    List<String>? interests,
    String? sort,
    int? page,
    int? size,
  }) async {
    final model = BaseSearchRequestModel(
      keyword: keyword,
      major: major,
      interests: interests,
      sort: sort,
      page: page,
      size: size,
    );

    final json = await remoteDatasource.search(model);

    if (json == null) return [];

    final res = UserDataModel.fromJson(json);

    return res.content;
  }

  @override
  Future<List<UserModel>> getRecommendUserList({
    required int page,
    required int size,
  }) async {
    final model = ListRequestModelBasePage(size: size, page: page);

    final json = await remoteDatasource.loadRecommendUserList(model);
    if (json != null) {
      final res = UserDataModel.fromJson(json);
      return res.content;
    }
    return [];
  }
}
