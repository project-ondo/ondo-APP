import 'package:ondo/data/models/user/response/user_model.dart';
import 'package:ondo/domain/entities/base/listable_wrapper.dart';

abstract class UserRepository {
  Future<ListableWrapper<UserModel>> search({
    String? keyword,
    String? major,
    List<String>? interests,
    String? sort,
    int? page,
    int? size,
  });

  Future<ListableWrapper<UserModel>> getRecommendUserList({required int page, required int size});
}
