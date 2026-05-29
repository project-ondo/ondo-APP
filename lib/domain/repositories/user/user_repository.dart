import 'package:ondo/data/models/user/response/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> search({
    String? keyword,
    String? major,
    List<String>? interests,
    String? sort,
    int? page,
    int? size,
  });

  Future<List<UserModel>> getRecommendUserList({required int page, required int size});

}
