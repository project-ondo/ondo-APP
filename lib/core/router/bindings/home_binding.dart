import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/search_binding.dart';
import 'package:ondo/domain/usecases/post/load_recent_popular_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/search/states/search_page_state.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    SearchBinding(pageState: SearchPageState.home).dependencies();

    ///HomeController 등록
    Get.lazyPut(
      () => HomeController(
        loadRecentPopularPostListUseCase:
            Get.find<LoadRecentPopularPostListUseCase>(),
        postSearchUseCase: Get.find<PostSearchUseCase>(),
        loadRecommendPostsUseCase: Get.find<LoadRecommendPostListUseCase>(),
        loadRecommendUsersUseCase: Get.find<LoadRecommendUsersUseCase>(),
        userSearchUseCase: Get.find<UserSearchUseCase>(),
        likePostUseCase: Get.find<LikePostUseCase>(),
        unlikePostUseCase: Get.find<UnlikePostUseCase>(),
        savePostLikeLocalUseCase: Get.find<SavePostLikeLocalUseCase>(),
        getCachedLikedPostIdsUseCase: Get.find<GetCachedLikedPostIdsUseCase>(),
      ),
    );
  }
}
