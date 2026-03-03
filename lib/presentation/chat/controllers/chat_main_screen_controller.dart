import 'package:get/get.dart';

class ChatMainScreenController extends GetxController {
  final RxList<String> tags = <String>[].obs;
  final List<ChatRoomInfo> _chatRooms = <ChatRoomInfo>[];
  final RxList<ChatRoomInfo> viewChatRooms = <ChatRoomInfo>[].obs;

  @override
  void onInit() {
    tags.addAll(_getTags());
    _chatRooms.addAll(_getChatRooms());
    viewChatRooms.addAll(_chatRooms);
    super.onInit();
  }

  void searchChatRooms(String text) {
    final Set<ChatRoomInfo> results = {};
    results.addAll(
      _chatRooms.where(
        (chatRoom) => chatRoom.name.contains(text),
      ),
    );
    viewChatRooms.clear();
    viewChatRooms.addAll(results.isNotEmpty ? results : _chatRooms);
  }
}

List<String> _getTags() => ["최근검색태그", "UI/UX", "Android", "멘토링", "팁", "공부인증"];

List<ChatRoomInfo> _getChatRooms() => [
  for (int i = 0; i < 8; i++) ...{
    (
      isBookmark: i < 2,
      name: i % 2 == 0 ? "감유찬" : "UI",
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
