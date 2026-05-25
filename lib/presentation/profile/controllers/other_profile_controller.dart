import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/chat_room_binding.dart';
import 'package:ondo/data/datasource/media/media_remote_datasource.dart';
import 'package:ondo/data/datasource/user/user_remote_datasource.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';
import 'package:ondo/domain/usecases/chat/create_chat_room_use_case.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

class OtherProfileController extends GetxController {
  final UserRemoteDatasource userRemoteDatasource = Get.find();
  final MediaRemoteDatasource mediaRemoteDatasource = Get.find();
  final CreateChatRoomUseCase createChatRoomUseCase = Get.find();

  final isLoading = false.obs;
  final Rxn<UserProfileDataModel> profile = Rxn();
  final profileImageUrl = RxnString();

  String? _currentPublicId;

  Future<void> loadProfile(String publicId) async {
    // 동일한 publicId면 재로딩 불필요
    if (_currentPublicId == publicId && profile.value != null) return;

    try {
      isLoading.value = true;
      // 새 프로필 로딩 시 기존 데이터 초기화
      profile.value = null;
      profileImageUrl.value = null;
      _currentPublicId = publicId;

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
      Get.snackbar('오류', '프로필을 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createChatRoom(String publicId) async {
    try {
      final roomId = await createChatRoomUseCase(publicId);
      if (roomId.isEmpty) {
        Get.snackbar('오류', '채팅방을 생성하지 못했습니다.');
        return;
      }
      await Get.to(
        () => ChatRoomScreen(roomId: roomId),
        binding: ChatRoomBinding(chatRoomId: roomId),
      );
    } catch (e) {
      debugPrint('Failed to create chat room: $e');
      Get.snackbar('오류', '채팅방 생성 중 오류가 발생했습니다.');
    }
  }
}