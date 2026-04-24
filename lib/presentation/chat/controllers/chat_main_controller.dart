import 'package:get/get.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/usecases/chat/block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

class ChatMainController extends GetxController {
  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<ChatEntity> _cacheChatRoomList = <ChatEntity>[];
  final RxList<ChatEntity> viewChatRoomList = <ChatEntity>[].obs;

  //TODO : error 객체 정의 및 error 처리 로직 추가
  final RxString error = "".obs;

  final LoadMyChatRoomListUseCase loadChatRoomsUseCase;
  final BlockChatRoomUseCase blockChatRoomUseCase;

  ChatMainController({
    required this.loadChatRoomsUseCase,
    required this.blockChatRoomUseCase,
  });

  @override
  void onInit() {
    tags.addAll(_getTags());
    _loadChatRooms();
    super.onInit();
  }

  Future<void> _loadChatRooms() async {
    _cacheChatRoomList.assignAll(
      await loadChatRoomsUseCase.call(page: 0, size: 10),
    );
    viewChatRoomList.assignAll(_cacheChatRoomList);
  }

  Future<void> _blockChatRoom(String chatRoomPublicId) async {
    final success = await blockChatRoomUseCase.call(chatRoomPublicId);
    if (success != true) {
      error.value = "BLOCK_FAILED";
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

  void enterChatRoom(int index) {
    //TODO : 웹소켓 연결, 채팅 방 접근에 대한 필요 정보를 전달히여 채팅 방 UI 생성
    final roomId = viewChatRoomList[index].roomId;
    //TODO : Get.to 접근 보다는 GoRoute 기법 활용
    Get.to(
      ChatRoomScreen(
        roomId: roomId,
      ),
      binding: BindingsBuilder(
        () => Get.put<ChatRoomController>(
          ChatRoomController(chatRoomId: roomId),
          tag: roomId,
        ),
      ),
    );
  }

  Future<void> blockingChat(int index) async {
    final roomId = viewChatRoomList[index].roomId;
    await _blockChatRoom(roomId);
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
