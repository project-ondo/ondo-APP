import 'package:ondo/data/models/post/response/post_model.dart';
import '../../../data/models/user/response/user_model.dart';

abstract class HomeRepository {
  Future<List<PostModel>> getRecommendPostList({required int page, required int size});

  Future<List<UserModel>> getRecommendUserList({required int page, required int size});
}
