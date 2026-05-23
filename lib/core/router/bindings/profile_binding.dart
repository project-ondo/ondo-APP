import 'package:get/get.dart';
import 'package:ondo/core/env.dart';
import 'package:ondo/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/notification/notification_local_datasource.dart';
import 'package:ondo/data/datasource/notification/notification_remote_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/auth/auth_repository_impl.dart';
import 'package:ondo/data/repositories/notification/notification_repository_impl.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';
import 'package:ondo/domain/usecases/auth/logout_usecase.dart';
import 'package:ondo/domain/usecases/notification/load_notification_setting_use_case.dart';
import 'package:ondo/domain/usecases/notification/update_notification_setting_use_case.dart';
import 'package:ondo/domain/usecases/user/delete_account_usecase.dart';
import 'package:ondo/presentation/profile/controllers/edit_profile_controller.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';
import 'package:ondo/presentation/profile/controllers/other_profile_controller.dart';
import 'package:ondo/presentation/profile/controllers/setting_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthLocalDatasource>()) {
      Get.lazyPut<AuthLocalDatasource>(
            () => AuthLocalDatasourceImpl(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthRemoteDatasource>()) {
      Get.lazyPut<AuthRemoteDatasource>(
            () => AuthRemoteDatasource(Env.apiBaseUrl),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthClient>()) {
      Get.lazyPut<AuthClient>(
            () => AuthClient(
          localDatasource: Get.find<AuthLocalDatasource>(),
          remoteDatasource: Get.find<AuthRemoteDatasource>(),
        ),
        fenix: true,
      );
    }

    /// AuthRepository 등록 (LogoutUseCase에 필요)
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(
        localDatasource: Get.find<AuthLocalDatasource>(),
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
      ),
    );

    /// LogoutUseCase 등록 (localDatasource 주입)
    Get.lazyPut<LogoutUseCase>(
          () => LogoutUseCase(
        repository: Get.find<AuthRepository>(),
        localDatasource: Get.find<AuthLocalDatasource>(),
      ),
    );

    /// 프로필 관련 datasource 등록
    Get.lazyPut<ProfileRemoteDatasource>(
          () => ProfileRemoteDatasource(client: Get.find<AuthClient>()),
      fenix: true,
    );

    /// 미디어 업로드/다운로드 datasource 등록
    Get.lazyPut<MediaRemoteDatasource>(
          () => MediaRemoteDatasource(client: Get.find<AuthClient>()),
      fenix: true,
    );

    /// UserRemoteDatasource 등록 (상대 프로필 조회에 필요)
    Get.lazyPut<UserRemoteDatasource>(
      () => UserRemoteDatasource(client: Get.find<AuthClient>()),
      fenix: true,
    );

    /// DeleteAccountUseCase 등록
    Get.lazyPut<DeleteAccountUseCase>(
          () => DeleteAccountUseCase(
        profileRemoteDatasource: Get.find<ProfileRemoteDatasource>(),
      ),
    );

    /// NotificationLocalDatasource 등록 (설정값 저장/불러오기용)
    if (!Get.isRegistered<NotificationLocalDatasource>()) {
      Get.lazyPut<NotificationLocalDatasource>(
            () => NotificationLocalDatasource(),
        fenix: true,
      );
    }

    /// NotificationRepositoryImpl 등록 (설정 UseCase에 필요)
    if (!Get.isRegistered<NotificationRepositoryImpl>()) {
      Get.lazyPut<NotificationRepositoryImpl>(
            () => NotificationRepositoryImpl(
          remoteDatasource: Get.find<NotificationRemoteDatasource>(),
          localDatasource: Get.find<NotificationLocalDatasource>(),
        ),
        fenix: true,
      );
    }

    /// 알림 설정 UseCase 등록
    Get.lazyPut<LoadNotificationSettingUseCase>(
          () => LoadNotificationSettingUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );
    Get.lazyPut<UpdateNotificationSettingUseCase>(
          () => UpdateNotificationSettingUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );

    /// MyProfileController 등록
    Get.lazyPut<MyProfileController>(
          () => MyProfileController(),
    );

    /// EditProfileController 등록
    Get.lazyPut<EditProfileController>(
          () => EditProfileController(),
    );

    /// OtherProfileController 등록
    Get.lazyPut<OtherProfileController>(
      () => OtherProfileController(),
    );

    /// SettingController 등록
    Get.lazyPut<SettingController>(
          () => SettingController(
        loadNotificationSettingUseCase:
        Get.find<LoadNotificationSettingUseCase>(),
        updateNotificationSettingUseCase:
        Get.find<UpdateNotificationSettingUseCase>(),
      ),
    );
  }
}
