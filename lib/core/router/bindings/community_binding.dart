import 'package:get/get.dart';
import 'package:ondo/data/datasource/post/post_local_datasource.dart';
import 'package:ondo/data/datasource/post/post_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/post/post_repository_impl.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/get_cached_liked_post_ids_use_case.dart';
import 'package:ondo/domain/usecases/post/get_recommend_posts_usecase.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/save_post_like_local_use_case.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDatasource>(
      () => PostRemoteDatasourceImpl(Get.find<AuthClient>()),
    );
    Get.lazyPut<PostLocalDatasource>(() => PostLocalDatasource());
    Get.lazyPut<PostRepositoryImpl>(
      () => PostRepositoryImpl(
        Get.find<PostRemoteDatasource>(),
        Get.find<PostLocalDatasource>(),
      ),
    );
    Get.lazyPut<GetRecommendPostsUseCase>(
      () => GetRecommendPostsUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<CreatePostUseCase>(
      () => CreatePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<UpdatePostUseCase>(
      () => UpdatePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<LikePostUseCase>(
      () => LikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<UnlikePostUseCase>(
      () => UnlikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<SavePostLikeLocalUseCase>(
      () => SavePostLikeLocalUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<GetCachedLikedPostIdsUseCase>(
      () => GetCachedLikedPostIdsUseCase(Get.find<PostRepositoryImpl>()),
    );

    Get.lazyPut<CommunityController>(
      () => CommunityController(
        likeUseCase: Get.find<LikePostUseCase>(),
        unlikeUseCase: Get.find<UnlikePostUseCase>(),
        getRecommendPostsUseCase: Get.find<GetRecommendPostsUseCase>(),
        savePostLikeLocalUseCase: Get.find<SavePostLikeLocalUseCase>(),
        getCachedLikedPostIdsUseCase: Get.find<GetCachedLikedPostIdsUseCase>(),
      ),
    );
  }
}
