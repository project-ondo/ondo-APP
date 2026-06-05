import 'package:get/get.dart';
import 'package:ondo/data/datasource/post/post_local_datasource.dart';
import 'package:ondo/data/datasource/post/post_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/post/post_repository_impl.dart';
import 'package:ondo/domain/usecases/post/bookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/liked_post_use_case.dart'; // ← 추가
import 'package:ondo/domain/usecases/post/load_recent_popular_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/load_recommend_post_list_use_case.dart';
import 'package:ondo/domain/usecases/post/post_search_use_case.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unbookmark_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDatasource>(
          () => PostRemoteDatasource(Get.find<AuthClient>()),
    );

    Get.lazyPut<PostLocalDatasource>(
          () => PostLocalDatasource(),
    );

    Get.lazyPut<PostRepositoryImpl>(
          () => PostRepositoryImpl(
        Get.find<PostRemoteDatasource>(),
        Get.find<PostLocalDatasource>(),
      ),
    );

    Get.lazyPut<LikePostUseCase>( // ← 서버 좋아요 요청
          () => LikePostUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<LikedPostUseCase>( // ← 로컬 캐시 확인
          () => LikedPostUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<UnlikePostUseCase>(
          () => UnlikePostUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<BookmarkPostUseCase>(
          () => BookmarkPostUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<UnbookmarkPostUseCase>(
          () => UnbookmarkPostUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<PostSearchUseCase>(
          () => PostSearchUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<SavePostLikeLocalUseCase>(
          () => SavePostLikeLocalUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut(
          () => LoadRecommendPostListUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut(
          () => LoadRecentPopularPostListUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut(
          () => PostController(),
    );
  }
}