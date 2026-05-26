import 'package:get/get.dart';
import 'package:ondo/data/datasource/rating/rating_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/rating/rating_repository_impl.dart';
import 'package:ondo/domain/usecases/rating/load_other_rating_list_use_case.dart';

class LoadRatingBinding extends Bindings {
  @override
  void dependencies() {
    //TODO : AuthBiding 적용

    if (!Get.isRegistered<RatingRemoteDatasource>()) {
      Get.lazyPut(
        () => RatingRemoteDatasource(client: Get.find<AuthClient>()),
      );
    }

    if (!Get.isRegistered<RatingRepositoryImpl>()) {
      Get.lazyPut(
        () => RatingRepositoryImpl(
          remoteDatasource: Get.find<RatingRemoteDatasource>(),
        ),
      );
    }
    if (!Get.isRegistered<LoadOtherRatingListUseCase>()) {
      Get.lazyPut(
        () => LoadOtherRatingListUseCase(
          repository: Get.find<RatingRepositoryImpl>(),
        ),
      );
    }
  }
}
