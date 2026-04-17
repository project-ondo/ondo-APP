import 'package:get/get.dart';
import 'package:ondo/domain/notification/notification_entity.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/presentation/notification/states/notification_state.dart';

class NotificationController extends GetxController {
  final List<NotificationEntity> _cacheNotificationList =
      <NotificationEntity>[].obs;
  final RxList<NotificationEntity> viewNotificationList =
      <NotificationEntity>[].obs;

  final LoadMyNotificationListUseCase loadMyNotificationListUseCase;

  NotificationController({required this.loadMyNotificationListUseCase});

  @override
  void onInit() async {
    await loadMyNotificationList();
    super.onInit();
  }

  Future<void> loadMyNotificationList() async {
    //TODO : 화면 연동 과정에서 범위 맞추기
    _cacheNotificationList.assignAll(
      await loadMyNotificationListUseCase.call(size: 20, page: 0),
    );
    viewNotificationList.assignAll(_cacheNotificationList);
  }

  void clear() {
    viewNotificationList.clear();
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
