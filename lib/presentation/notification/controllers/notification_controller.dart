import 'package:get/get.dart';
import 'package:ondo/presentation/notification/states/notification_state.dart';

class NotificationController extends GetxController {
  final RxList<NotificationItem> notificationList = <NotificationItem>[].obs;

  @override
  void onInit() {
    notificationList.addAll(getNotifications());
    super.onInit();
  }

  void clear() {
    notificationList.clear();
  }
}

extension DummyModel on NotificationController {
  List<NotificationItem> getNotifications() => [
    for (int i = 0; i < 3; i++) ...{
      (
        type: NotificationState.newComment,
        comment: "김유찬: ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.newComment,
        comment: "김유찬: UI 피로도가 ㄹㅈㄷ 도대체 왜 숨기는겨",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.newComment,
        comment: "김유찬: ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.newComment,
        comment: "김유찬: 진짜 ㄹㅇ 계정 탈퇴 한번 하려면 이거하고 저거하고 귀찮아 죽겠음 진짜",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.requestChat,
        comment: "김유찬: 진짜 ㄹㅇ계정 탈퇴 한번 하려면 이거하고 저거하고 귀찮아 죽겠음 진짜",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.reported,
        comment: null,
        sendAt: null,
        profileImg: null,
      ),
      (
        type: NotificationState.newReview,
        comment: null,
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: NotificationState.overHeart,
        comment: "요즘 UI UX",
        sendAt: Duration(),
        profileImg: null,
      ),
    },
  ];
}

typedef NotificationItem = ({
  NotificationState type,
  String? comment,
  String? profileImg,
  Duration? sendAt,
});
