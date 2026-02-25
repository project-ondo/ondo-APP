import 'package:get/get.dart';

class PostViewController extends GetxController {
  RxString title = "".obs;
  RxString authorName = "".obs;
  Rx<Duration> postAt = Duration().obs;
  bool selectHeart = false;
  bool selectBookMark = false;
  int heartTotal = 0;
  int bookMarkTotal = 0;
  RxList<String> postTags = <String>[].obs;
  RxString bodyText = "".obs;
  RxList<Comment> comments = <Comment>[].obs;

  @override
  void onInit() {
    title.value = getTitle();
    authorName.value = getAuthor();
    postAt.value = getPostAt();
    selectHeart = getSelectHeart();
    selectBookMark = getSelectBookMark();
    heartTotal = getHeartTotal();
    bookMarkTotal = getBookMarkTotal();
    postTags.value = getPostTags();
    bodyText.value = getBodyText();
    comments.value = getComments();

    super.onInit();
  }
}

extension DummyData on PostViewController {
  String getTitle() => "요즘 UI UX";

  String getAuthor() => "김유찬";

  Duration getPostAt() => Duration(minutes: 4);

  bool getSelectHeart() => false;
  bool getSelectBookMark() => true;
  int getHeartTotal() => 12;
  int getBookMarkTotal() => 12;

  List<String> getPostTags() => ["#UI/UX", "#FrontEnd"];

  String getBodyText() => """요즘 UI·UX 이슈 보면, 기술은 엄청 발전했는데 사용자 입장은 좀 
애매해짐. AI 추천이니 자동 생성이니 많아졌는데, 솔직히 왜 그게 뜨는지 모르겠음. 내가 선택한 건지, 그냥 떠밀린 건지 경계가 흐려짐.

개인화도 마찬가지임. 처음엔 편한데 쓰다 보면 피곤함. 설정 건드릴 
여지도 없고, 앱이 “너 이거 좋아하잖아” 하고 단정 짓는 느낌 듦. 다크 
패턴은 말할 것도 없고, 가입은 한 번에 되는데 탈퇴는 왜 이렇게 
숨겨놓는지 아직도 이해 안 감.

접근성도 형식만 맞춘 경우 많음. 체크리스트는 통과했는데 실제로 써보면 불편함. 애니메이션, 효과 잔뜩 넣은 UI도 처음엔 와 소리 나오는데, 정보 찾으려면 오히려 방해됨.

결국 요즘 UX 문제는 기술 부족이 아니라 태도 문제 같음. 사용자를 배려한다면서 사실은 컨트롤하려는 설계. 이제는 “얼마나 오래 쓰게 만드나” 말고 “얼마나 덜 스트레스 받게 하나”로 가야 하지 않나 싶음.""";

  List<Comment> getComments() => [
    for (int i = 0; i < 3; i++) ...{
      (
        author: "김유찬",
        heartTotal: 12,
        conment: "ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
      ),
      (author: "김유찬", heartTotal: 12, conment: "UI 피로도가 ㄹㅈㄷ 도대체 왜 숨기는겨"),
      (
        author: "김유찬",
        heartTotal: 16,
        conment: "ㄹㅇ 다크 패턴은 진짜 법으로 좀 쳐야 함… 탈퇴 버튼 숨겨놓는 거 볼 때마다 정 떨어짐.",
      ),
      (
        author: "김유찬",
        heartTotal: 12,
        conment: "진짜 ㄹㅇ 계정 탈퇴 한번 하려면 이거하고 저거하고 귀찮아 죽겠음 진짜",
      ),
    },
  ];
}

typedef Comment = ({String author, String conment, int heartTotal});
