import 'package:ondo/data/models/post/response/post_model.dart';

abstract class HomeRepository {
  Future<List<PostModel>> getRecommendPostList({required int page, required int size});

}
