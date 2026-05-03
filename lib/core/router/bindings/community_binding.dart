import 'package:get/get.dart';
import 'package:ondo/data/datasource/post/post_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/post/post_repository_impl.dart';
import 'package:ondo/domain/usecases/post/like_post_usecase.dart';
import 'package:ondo/domain/usecases/post/unlike_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PostRemoteDatasource>(
      PostRemoteDatasourceImpl(Get.find<AuthClient>()),
    );
    Get.put<PostRepositoryImpl>(
      PostRepositoryImpl(Get.find<PostRemoteDatasource>()),
    );
    Get.put<LikePostUseCase>(
      LikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.put<UnlikePostUseCase>(
      UnlikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.put<CommunityController>(
      CommunityController(
        likeUseCase: Get.find<LikePostUseCase>(),
        unlikeUseCase: Get.find<UnlikePostUseCase>(),
      ),
    );
  }
}