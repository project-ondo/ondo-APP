import 'package:get/get.dart';
import 'package:ondo/presentation/chat/controllers/chat_controller.dart';
import 'package:ondo/presentation/chat/screens/chat_room_screen.dart';

class ChatMainScreenController extends GetxController {
  final List<String> tags = <String>[].obs;
  final RxSet<String> selectTagList = <String>{}.obs;
  final List<ChatRoomInfo> _cacheChatList = <ChatRoomInfo>[];
  final RxList<ChatRoomInfo> viewChatList = <ChatRoomInfo>[].obs;

  @override
  void onInit() {
    tags.addAll(_getTags());
    _cacheChatList.addAll(_getChatRooms());
    viewChatList.addAll(_cacheChatList);
    super.onInit();
  }

  void searchChatRooms(List<String> searchList) {
    //TODO : 채팅 리스트 조회 (아마도 서버로부터 불러옴)
    //임시 조회 결과 객체
    final Set<ChatRoomInfo> results = {};
    results.addAll(
      _cacheChatList.where(
        (chatRoom) => searchList.any(
          (search) => chatRoom.name.contains(search),
        ),
      ),
    );
    //보여지는 채잍 방 리스토 갱신
    viewChatList.clear();
    viewChatList.addAll(results);
  }

  void filterChatRooms(String tag, bool isSelect) {
    //TODO : 태그 필터 젹용, 불러온 cache에서 거를지, 서버로부터 불러올 지, 서버 연결 시 검토 요함
    //임시 조회 결과
    isSelect ? selectTagList.add(tag) : selectTagList.remove(tag);
    //선택한 tag가 없을 시 전체 표시
    if (selectTagList.isEmpty) {
      viewChatList.assignAll(_cacheChatList);
      return;
    }
    final Set<ChatRoomInfo> result = {};
    result.addAll(
      viewChatList.where(
        (chat) => selectTagList.any((tag) => chat.name.contains(tag)),
      ),
    );
    //보여지는 채팅 방 리스트 갱신
    viewChatList.assignAll(result);
  }

  void enterChatRoom() {
    //TODO : 웹소켓 연결, 채팅 방 접근에 대한 필요 정보를 전달히여 채팅 방 UI 생성
    Get.put(ChatController());
    Get.to(ChatRoomScreen());
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

List<ChatRoomInfo> _getChatRooms() => [
  for (int i = 0; i < 8; i++) ...{
    (
      isBookmark: i < 2,
      name: i % 2 == 0 ? "김유찬" : "UI",
      lastChat: "ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
      lastChatAt: Duration(hours: i),
      newChatCount: i,
    ),
  },
];

typedef ChatRoomInfo = ({
  bool isBookmark,
  String name,
  Duration lastChatAt,
  String lastChat,
  int newChatCount,
});
