import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/chat_room_binding.dart';
import 'package:ondo/core/utils/app_snackbar.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/domain/entities/rating/rating_entity.dart';
import 'package:ondo/domain/usecases/rating/load_other_rating_list_use_case.dart';
import 'package:ondo/domain/usecases/chat/create_chat_room_use_case.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

class OtherProfileController extends GetxController {
  final UserRemoteDatasource userRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();
  final CreateChatRoomUseCase createChatRoomUseCase = Get.find();
  final LoadOtherRatingListUseCase loadOtherRatingListUseCase;

  final List<RatingEntity> _cacheRatingList = [];
  final RxList<RatingEntity> viewRatingList = RxList();
  int _ratingCursor = 0;
  bool _ratingHasNext = true;
  final RxBool isLoadingRatings = false.obs;

  OtherProfileController({
    required this.loadOtherRatingListUseCase,
  });

  final isLoading = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();
  final profileImageUrl = RxnString();

  //TODO : userPublicId 생성자로 할당
  String? userPublicId;

  //TODO : 구조 변경
  Future<void> loadProfile(String publicId) async {
    // 동일한 publicId면 재로딩 불필요
    if (userPublicId == publicId && profile.value != null) return;

    try {
      isLoading.value = true;
      // 새 프로필 로딩 시 기존 데이터 초기화
      profile.value = null;
      profileImageUrl.value = null;
      userPublicId = publicId;

      profile.value = await userRemoteDatasource.getOtherProfile(publicId);

      final imageKey = profile.value?.profileImageKey;
      if (imageKey != null && imageKey.isNotEmpty) {
        profileImageUrl.value = await mediaRemoteDatasource.getDownloadUrl(
          key: imageKey,
        );
      } else {
        profileImageUrl.value = null;
      }
    } catch (e, s) {
      debugPrint('Failed to load other profile: $e\n$s');
      AppSnackbar.showError('프로필을 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createChatRoom(String publicId) async {
    if (isLoading.value) return;
    if (profile.value == null) {
      AppSnackbar.showError('상대방 프로필 정보를 불러오는 중입니다.');
      return;
    }

    try {
      isLoading.value = true;
      final roomId = await createChatRoomUseCase(publicId);
      if (roomId.isEmpty) {
        AppSnackbar.showError('채팅방을 생성하지 못했습니다.');
        return;
      }
      await Get.to(
        () => ChatRoomScreen(roomId: roomId),
        binding: ChatRoomBinding(
          chatRoomId: roomId,
          opponentDisplayName: profile.value?.displayName ?? '',
          opponentProfileImageKey: profile.value?.profileImageKey,
        ),
      );
    } catch (e, s) {
      debugPrint('Failed to create chat room: $e\n$s');
      AppSnackbar.showError('채팅방 생성 중 오류가 발생했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRatingList(String userPublicId) async {
    this.userPublicId = userPublicId;
    _ratingCursor = 0;
    _ratingHasNext = true;
    _cacheRatingList.clear();
    viewRatingList.clear();
    await loadMoreRatings();
  }

  Future<void> loadMoreRatings() async {
    final publicId = userPublicId;
    if (publicId == null || !_ratingHasNext || isLoadingRatings.value) return;

    isLoadingRatings.value = true;
    try {
      final result = await loadOtherRatingListUseCase.call(
        userPublicId: publicId,
        cursor: _ratingCursor,
        size: 20,
      );
      _cacheRatingList.addAll(result.pages);
      viewRatingList.assignAll(_cacheRatingList);
      _ratingHasNext = result.hasNext;
      _ratingCursor = result.nextCursor ?? _ratingCursor;
    } catch (e) {
      debugPrint('[OtherProfileController] 평점 목록 조회 실패 - error: $e');
    } finally {
      isLoadingRatings.value = false;
    }
  }
}
