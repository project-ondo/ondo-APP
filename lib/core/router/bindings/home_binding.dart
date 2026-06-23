import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/search_binding.dart';
import 'package:ondo/domain/usecases/post/load_recent_popular_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmarked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_bookmark_local_use_case.dart';
import 'package:ondo/domain/usecases/user/user_search_use_case.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/search/states/search_page_state.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    SearchBinding(pageState: SearchPageState.home).dependencies();

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
        likedPostUseCase: Get.find<LikedPostUseCase>(),
        bookmarkPostUseCase: Get.find<BookmarkPostUseCase>(),
        unbookmarkPostUseCase: Get.find<UnbookmarkPostUseCase>(),
        savePostBookmarkLocalUseCase: Get.find<SavePostBookmarkLocalUseCase>(),
        bookmarkedPostUseCase: Get.find<BookmarkedPostUseCase>(),
      ),
    );
  }
}