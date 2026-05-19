import 'package:get/get.dart';
import 'package:ondo/data/datasource/post/post_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/post/post_repository_impl.dart';
import 'package:ondo/domain/usecases/post/get_recommend_posts_usecase.dart';
import 'package:ondo/domain/usecases/user/load_recommend_users_use_case.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

import '../../../data/repositories/user/user_repository_impl.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDatasource>(
      () => PostRemoteDatasourceImpl(Get.find<AuthClient>()),
    );
    Get.lazyPut<PostRepositoryImpl>(
      () => PostRepositoryImpl(Get.find<PostRemoteDatasource>()),
    );

    ///홈 추천 게시물 관련 usecase 등록
    Get.lazyPut(
      () => GetRecommendPostsUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    ///홈 추천 유저 관련 usecase 등록
    Get.lazyPut(
      () => LoadRecommendUsersUseCase(
        repository: Get.find<UserRepositoryImpl>(),
      ),
    );

    ///HomeController 등록
    Get.lazyPut(
      () => HomeController(
        recommendPostsUseCase: Get.find<GetRecommendPostsUseCase>(),
        recommendUsersUseCase: Get.find<LoadRecommendUsersUseCase>(),
      ),
    );
  }
}
