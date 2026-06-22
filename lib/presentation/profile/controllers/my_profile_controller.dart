import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/utils/app_snackbar.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/usecases/auth/logout_usecase.dart';
import 'package:ondo/domain/usecases/rating/load_my_rating_list_use_case.dart';
import 'package:ondo/domain/usecases/user/delete_account_usecase.dart';

class MyProfileController extends GetxController {
  final LoadMyRatingListUseCase loadMyRatingListUseCase;

  MyProfileController({required this.loadMyRatingListUseCase});

  final List<RatingEntity> _cacheRatingList = [];
  final RxList<RatingEntity> viewRatingList = RxList();
  int _ratingCursor = 0;
  bool _ratingHasNext = true;
  final RxBool isLoadingRatings = false.obs;

  //TODO : 생성자 객체 할당 방식으로 변경
  final ProfileRemoteDatasource profileRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();
  final LogoutUseCase logoutUseCase = Get.find();
  final DeleteAccountUseCase deleteAccountUseCase = Get.find();

  final isLoading = false.obs;
  final profileLoadFailed = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();
  final profileImageUrl = RxnString();

  int _imageRefreshCount = 0;

  @override
  void onInit() {
    _resetAndLoadRatings();
    loadProfile();
    super.onInit();
  }

  Future<void> loadProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      profileLoadFailed.value = false;
      _imageRefreshCount = 0;
      profile.value = await profileRemoteDatasource.getMyProfile();
    } catch (e, s) {
      debugPrint('Failed to load my profile: $e\n$s');
      profileLoadFailed.value = true;
      return;
    } finally {
      isLoading.value = false;
    }

    // 이미지 URL은 별도로 처리 — 실패해도 프로필 화면은 정상 표시
    final imageKey = profile.value?.profileImageKey;
    if (imageKey != null && imageKey.isNotEmpty) {
      try {
        profileImageUrl.value = await mediaRemoteDatasource.getDownloadUrl(
          key: imageKey,
        );
      } catch (e) {
        debugPrint('Failed to load profile image URL: $e');
        profileImageUrl.value = null;
      }
    } else {
      profileImageUrl.value = null;
    }
  }

  // presign URL 만료 시 재발급 — 최대 1회 재시도
  void refreshProfileImageUrl() {
    if (_imageRefreshCount >= 1) return;
    _imageRefreshCount++;
    _fetchAndSetImageUrl(profile.value?.profileImageKey);
  }

  Future<void> _fetchAndSetImageUrl(String? imageKey) async {
    if (imageKey == null || imageKey.isEmpty) return;
    try {
      profileImageUrl.value = await mediaRemoteDatasource.getDownloadUrl(
        key: imageKey,
      );
    } catch (e) {
      debugPrint('Failed to refresh profile image URL: $e');
    }
  }

  /// refreshToken 분기 로직은 LogoutUseCase에서 처리
  /// 네비게이션은 Screen에서 처리 (context.go)
  Future<void> logout(BuildContext context) async {
    try {
      await logoutUseCase();
    } catch (e, s) {
      debugPrint('Failed to logout: $e\n$s');
    }
  }

  Future<bool> deleteAccount() async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      await deleteAccountUseCase();
      return true;
    } catch (e, s) {
      debugPrint('Failed to delete account: $e\n$s');
      AppSnackbar.showError('회원탈퇴에 실패했습니다.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _resetAndLoadRatings() {
    _ratingCursor = 0;
    _ratingHasNext = true;
    _cacheRatingList.clear();
    loadMoreRatings();
  }

  Future<void> loadMoreRatings() async {
    if (!_ratingHasNext || isLoadingRatings.value) return;

    isLoadingRatings.value = true;
    try {
      final result = await loadMyRatingListUseCase.call(_ratingCursor, 20);
      _cacheRatingList.addAll(result.pages);
      viewRatingList.assignAll(_cacheRatingList);
      _ratingHasNext = result.hasNext;
      _ratingCursor = result.nextCursor ?? _ratingCursor;
    } catch (e) {
      debugPrint('[MyProfileController] 평점 목록 조회 실패 - error: $e');
    } finally {
      isLoadingRatings.value = false;
    }
  }
}
