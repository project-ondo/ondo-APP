import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/models/user/request/user_search_request_model.dart';
import 'package:ondo/data/models/user/response/user_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/repositories/user/user_repository.dart';

import '../../models/base/request/base_list_request_model.dart';

class UserRepositoryImpl extends UserRepository {
  UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ListableWrapper<UserModel>> search({
    String? keyword,
    String? major,
    List<String>? interests,
    String? sort,
    int? page,
    int? size,
  }) async {
    final model = UserSearchRequestModel(
      keyword: keyword,
      major: major,
      interests: interests,
      sort: sort,
      page: page,
      size: size,
    );

    final json = await remoteDatasource.search(model);

    if (json == null) return ListableWrapper.none();

    final res = UserDataModel.fromJson(json);
    return ListableWrapper<UserModel>(
      content: res.content,
      page: res.page,
      size: res.size,
      totalElements: res.totalElements,
      totalPages: res.totalPages,
      last: res.last,
    );
  }

  @override
  Future<ListableWrapper<UserModel>> getRecommendUserList({
    required int page,
    required int size,
  }) async {
    final model = ListRequestModelBasePage(size: size, page: page);

    final json = await remoteDatasource.loadRecommendUserList(model);
    if (json == null) return ListableWrapper.none();

    final res = UserDataModel.fromJson(json);
    return ListableWrapper<UserModel>(
      content: res.content,
      page: res.page,
      size: res.size,
      totalElements: res.totalElements,
      totalPages: res.totalPages,
      last: res.last,
    );
  }
}
