import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/chat_room_binding.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/usecases/chat/block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/cancel_block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/domain/usecases/chat/turn_off_chat_notification_use_case.dart';
import 'package:ondo/domain/usecases/chat/turn_on_chat_notification_use_case.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';
import 'package:ondo/presentation/chat/states/chat_room_back_result.dart';

class ChatMainController extends GetxController {
  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<ChatEntity> _cacheChatRoomList = <ChatEntity>[];
  final RxList<ChatEntity> viewChatRoomList = <ChatEntity>[].obs;

  //TODO : error 객체 정의 및 error 처리 로직 추가
  final RxString error = "".obs;

  ///채팅 관련 usecase들
  final LoadMyChatRoomListUseCase loadChatRoomsUseCase;
  final BlockChatRoomUseCase blockChatRoomUseCase;
  final CancelBlockChatRoomUseCase cancelBlockChatRoomUseCase;
  final TurnOnChatNotificationUseCase turnOnChatNotificationUseCase;
  final TurnOffChatNotificationUseCase turnOffChatNotificationUseCase;

  ChatMainController({
    required this.loadChatRoomsUseCase,
    required this.blockChatRoomUseCase,
    required this.cancelBlockChatRoomUseCase,
    required this.turnOnChatNotificationUseCase,
    required this.turnOffChatNotificationUseCase,
  });

  int _currentPage = 0;
  bool _hasMore = true;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  static const int _pageSize = 20;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    tags.addAll(_getTags());
    _loadChatRooms();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreChatRooms();
    }
  }

  Future<void> _loadChatRooms() async {
    _currentPage = 0;
    _hasMore = true;
    error.value = '';
    isLoading.value = true;
    try {
      final result = await loadChatRoomsUseCase.call(page: 0, size: _pageSize);
      _cacheChatRoomList.assignAll(result);
      viewChatRoomList.assignAll(_cacheChatRoomList);
      if (result.length < _pageSize) _hasMore = false;
    } catch (e) {
      debugPrint('[ChatMainController] 채팅 목록 조회 실패 - error: $e');
      error.value = '채팅 목록을 불러오지 못했어요.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryLoadChatRooms() => _loadChatRooms();

  Future<void> loadMoreChatRooms() async {
    if (!_hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _currentPage + 1;
      final result = await loadChatRoomsUseCase.call(
        page: nextPage,
        size: _pageSize,
      );

      if (result.isEmpty || result.length < _pageSize) _hasMore = false;

      _currentPage = nextPage;
      _cacheChatRoomList.addAll(result);
      viewChatRoomList.assignAll(_cacheChatRoomList);
    } catch (e) {
      debugPrint('[ChatMainController] 채팅 목록 추가 로드 실패 - error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _cancelBlockChatRoom(String chatRoomPublicId) async {
    final success = await cancelBlockChatRoomUseCase.call(chatRoomPublicId);
    if (success != true) {
      error.value = "CANCEL_BLOCK_FAILED";
    }
  }

  //TODO : 디자인에서 해당 알림 설정을 어떻게 할 건지 정의되면 구조 변경
  Future<void> turnOnNotification(ChatEntity chat) async {
    final success = await turnOnChatNotificationUseCase.call(chat.roomId);
    if (!success) error.value = "TURN_ON_NOTIFICATION_FAILED";
  }

  Future<void> turnOffNotification(ChatEntity chat) async {
    final success = await turnOffChatNotificationUseCase.call(chat.roomId);
    if (!success) error.value = "TURN_OFF_NOTIFICATION_FAILED";
  }

  void search(String query, List<String> tags) {
    //임시 조회 결과 객체
    final Set<ChatEntity> results = {};
    results.addAll(
      _cacheChatRoomList.where(
        (room) =>
            room.opponentDisplayName.contains(query) ||
            room.lastMessagePreview.contains(query),
      ),
    );
    //조회 결과 화면 반영
    viewChatRoomList.assignAll(results);
  }

  void _filterChatRooms() {
    final Set<ChatEntity> result = {};

    ///선택한 태그가 없을 경우, 전체 채팅 방 리스트 표시
    if (selectTagList.isEmpty) {
      viewChatRoomList.assignAll(_cacheChatRoomList);
      return;
    }

    result.addAll(
      _cacheChatRoomList.where(
        (room) => selectTagList.any(
          (tag) => room.opponentDisplayName.contains(tag),
        ),
      ),
    );

    ///보여지는 채팅 방 리스트 갱신
    viewChatRoomList.assignAll(result);
  }

  void selectTag(String tag, bool isSelect) {
    isSelect ? selectTagList.add(tag) : selectTagList.remove(tag);
    _filterChatRooms();
  }

  Future<void> enterChatRoom(int index) async {
    //TODO : 웹소켓 연결, 채팅 방 접근에 대한 필요 정보를 전달히여 채팅 방 UI 생성
    final chat = viewChatRoomList[index];
    //TODO : route 정의 이후에 방식 변경
    final result = await Get.to<ChatRoomBackResult>(
      () => ChatRoomScreen(roomId: chat.roomId),
      binding: ChatRoomBinding(
        chatRoomId: chat.roomId,
        opponentDisplayName: chat.opponentDisplayName,
        opponentProfileImageKey: chat.opponentProfileImageKey,
      ),
    );

    switch (result) {
      case ChatRoomReadResult():
        if (result.success) {
          _cacheChatRoomList
                  .firstWhereOrNull((room) => room.roomId == chat.roomId)
                  ?.read =
              true;
          viewChatRoomList.assignAll(_cacheChatRoomList);
        }
        break;
      case ChatRoomQuitResult():
        if (result.success) {
          _cacheChatRoomList.removeWhere(
            (room) => room.roomId == chat.roomId,
          );
          viewChatRoomList.assignAll(_cacheChatRoomList);
        }
        break;
      case null:
    }

    viewChatRoomList.refresh();
  }

  Future<void> blockingChat(int index) async {
    final roomId = viewChatRoomList[index].roomId;
    final success = await blockChatRoomUseCase.call(roomId);
    if (success == true) {
      _cacheChatRoomList.removeWhere(
        (room) => room.roomId == roomId,
      );
      viewChatRoomList.assignAll(_cacheChatRoomList);
    } else {
      error.value = "BLOCK_FAILED";
    }
  }

  Future<void> cancelBlockingChat(int index) async {
    final roomId = viewChatRoomList[index].roomId;
    await _cancelBlockChatRoom(roomId);
  }
}

List<String> _getTags() => [
  "최근검색태그",
  "UI/UX",
  "Android",
  "멘토링",
  "팁",
  "공부인증",
  "김유찬",
];
