import 'package:get/get.dart';
import '../../../data/datasource/post/post_remote_datasource.dart';
import '../../../data/network/clients/auth_client.dart';
import '../../../data/repositories/post/post_repository_impl.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/delete_post_usecase.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';
import '../../../presentation/post/controllers/post_view_controller.dart';

class PostBinding extends Bindings {
  final int postId;
  final bool isFavorite;
  PostBinding(this.postId, [this.isFavorite = false]);

  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDatasource>(
      () => PostRemoteDatasourceImpl(Get.find<AuthClient>()),
    );
    Get.lazyPut<PostRepositoryImpl>(
      () => PostRepositoryImpl(Get.find<PostRemoteDatasource>()),
    );
    Get.lazyPut<GetPostDetailUseCase>(
      () => GetPostDetailUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<CreatePostUseCase>(
      () => CreatePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<UpdatePostUseCase>(
      () => UpdatePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<DeletePostUseCase>(
      () => DeletePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<LikePostUseCase>(
      () => LikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    Get.lazyPut<UnlikePostUseCase>(
      () => UnlikePostUseCase(Get.find<PostRepositoryImpl>()),
    );
    //TODO : tag가 메모리에 남는 경우 delete 로직 추가
    Get.put<PostViewController>(
      tag: postId.toString(),
      PostViewController(
        postId: postId,
        initialIsFavorite: isFavorite,
        useCase: Get.find<GetPostDetailUseCase>(),
        updateUseCase: Get.find<UpdatePostUseCase>(),
        deleteUseCase: Get.find<DeletePostUseCase>(),
        likeUseCase: Get.find<LikePostUseCase>(),
        unlikeUseCase: Get.find<UnlikePostUseCase>(),
      ),
    );
  }
}
