import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/search_binding.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/bookmarked_post_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_bookmark_local_use_case.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/search/states/search_page_state.dart';

class CommunityBinding extends Bindings {
  @override
  void dependencies() {
    SearchBinding(pageState: SearchPageState.community).dependencies();

    Get.lazyPut<CommunityController>(
          () => CommunityController(
        likeUseCase: Get.find<LikePostUseCase>(),
        unlikeUseCase: Get.find<UnlikePostUseCase>(),
        getRecommendPostsUseCase: Get.find<LoadRecommendPostListUseCase>(),
        savePostLikeLocalUseCase: Get.find<SavePostLikeLocalUseCase>(),
        likedPostUseCase: Get.find<LikedPostUseCase>(),
        bookmarkUseCase: Get.find<BookmarkPostUseCase>(),
        unbookmarkUseCase: Get.find<UnbookmarkPostUseCase>(),
        savePostBookmarkLocalUseCase: Get.find<SavePostBookmarkLocalUseCase>(),
        bookmarkedPostUseCase: Get.find<BookmarkedPostUseCase>(),
        postSearchUseCase: Get.find<PostSearchUseCase>(),
      ),
    );
  }
}