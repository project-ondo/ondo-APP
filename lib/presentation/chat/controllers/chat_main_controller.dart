import 'package:get/get.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

class ChatMainController extends GetxController {
  final List<String> tags = <String>[].obs;
  final Set<String> selectTagList = <String>{};
  final List<ChatEntity> _cacheChatRoomList = <ChatEntity>[];
  final RxList<ChatEntity> viewChatRoomList = <ChatEntity>[].obs;

  final LoadMyChatRoomListUseCase loadChatRoomsUseCase;

  ChatMainController({required this.loadChatRoomsUseCase});

  @override
  void onInit() {
    tags.addAll(_getTags());
    loadChatRooms();
    super.onInit();
  }

  Future<void> loadChatRooms() async {
    _cacheChatRoomList.assignAll(
      await loadChatRoomsUseCase.call(page: 0, size: 10),
    );
    viewChatRoomList.assignAll(_cacheChatRoomList);
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
    Get.lazyPut<ChatRoomController>(
      () => ChatRoomController(chatRoomId: roomId),
      tag: roomId,
    );
    Get.to(
      ChatRoomScreen(
        roomId: roomId,
      ),
    );
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

typedef ChatRoomInfo = ({
  bool isBookmark,
  String name,
  Duration lastChatAt,
  String lastChat,
  int newChatCount,
});
