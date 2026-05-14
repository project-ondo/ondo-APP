import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/chat_room_binding.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/usecases/chat/block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/cancel_block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/domain/usecases/chat/read_chat_message_use_case.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

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
  final ReadChatMessageUseCase readChatMessageUseCase;

  ChatMainController({
    required this.loadChatRoomsUseCase,
    required this.blockChatRoomUseCase,
    required this.cancelBlockChatRoomUseCase,
    required this.readChatMessageUseCase,
  });

  @override
  void onInit() {
    tags.addAll(_getTags());
    _loadChatRooms();
    super.onInit();
  }

  Future<void> _loadChatRooms() async {
    //TODO 구조 변경
    _cacheChatRoomList.assignAll(
      await loadChatRoomsUseCase.call(page: 0, size: 10),
    );
    viewChatRoomList.assignAll(_cacheChatRoomList);
  }

  Future<void> _cancelBlockChatRoom(String chatRoomPublicId) async {
    final success = await cancelBlockChatRoomUseCase.call(chatRoomPublicId);
    if (success != true) {
      error.value = "CANCEL_BLOCK_FAILED";
    }
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
        (room) =>
            selectTagList.any((tag) => room.opponentDisplayName.contains(tag)),
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
    final roomId = viewChatRoomList[index].roomId;
    //TODO : route 정의 이후에 방식 변경
    viewChatRoomList[index].read =
        await Get.to<bool>(
          ChatRoomScreen(roomId: roomId),
          binding: ChatRoomBinding(chatRoomId: roomId),
        ) ??
        false;
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
