import 'package:get/get.dart';
import 'package:ondo/presentation/alert/states/alert_state.dart';

class AlertController extends GetxController {
  final RxList<Alert> alertList = <Alert>[].obs;

  @override
  void onInit() {
    alertList.addAll(getAlerts());
    super.onInit();
  }

  void clear() {
    alertList.clear();
  }
}

extension DummyModel on AlertController {
  List<Alert> getAlerts() => [
    for (int i = 0; i < 3; i++) ...{
      (
        type: AlertState.newComment,
        comment: "김유찬: ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.newComment,
        comment: "김유찬: UI 피로도가 ㄹㅈㄷ 도대체 왜 숨기는겨",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.newComment,
        comment: "김유찬: ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.newComment,
        comment: "김유찬: 진짜 ㄹㅇ 계정 탈퇴 한번 하려면 이거하고 저거하고 귀찮아 죽겠음 진짜",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.requestChat,
        comment: "김유찬: 진짜 ㄹㅇ계정 탈퇴 한번 하려면 이거하고 저거하고 귀찮아 죽겠음 진짜",
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.reported,
        comment: null,
        sendAt: null,
        profileImg: null,
      ),
      (
        type: AlertState.newReview,
        comment: null,
        sendAt: Duration(),
        profileImg: null,
      ),
      (
        type: AlertState.overHeart,
        comment: "요즘 UI UX",
        sendAt: Duration(),
        profileImg: null,
      ),
    },
  ];
}

typedef Alert = ({
  AlertState type,
  String? comment,
  String? profileImg,
  Duration? sendAt,
});
