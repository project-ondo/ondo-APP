import 'package:get/get.dart';
import 'package:ondo/data/datasource/home/home_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/home/home_repository_impl.dart';
import 'package:ondo/data/repositories/search/user_repository_impl.dart';
import 'package:ondo/domain/usecases/home/load_recommend_posts_use__case.dart';
import 'package:ondo/domain/usecases/home/load_recommend_users_use_case.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    ///홈 화면과 연관되는 api 관련 dataSource
    Get.lazyPut<HomeRemoteDatasource>(
      () => HomeRemoteDatasource(client: Get.find<AuthClient>()),
    );

    ///홈 화면과 연관되는 api 관련 repository
    Get.lazyPut<HomeRepositoryImpl>(
      () => HomeRepositoryImpl(datasource: Get.find<HomeRemoteDatasource>()),
    );

    ///홈 추천 게시물 관련 usecase 등록
    Get.lazyPut(
      () => LoadRecommendPostsUseCase(
        homeRepository: Get.find<HomeRepositoryImpl>(),
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
        recommendPostsUseCase: Get.find<LoadRecommendPostsUseCase>(),
        recommendUsersUseCase: Get.find<LoadRecommendUsersUseCase>(),
        userSearchUseCase: Get.find<UserSearchUseCase>(),
      ),
    );
  }
}
