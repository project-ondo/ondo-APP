import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/post_view_controller.dart';
import 'package:ondo/presentation/community/widgets/community_custom_icon_button.dart';


class CommunityPostDetailScreen extends StatefulWidget {
  const CommunityPostDetailScreen.myPost({super.key}) : isMy = true;

  const CommunityPostDetailScreen.otherPost({super.key}) : isMy = false;

  final bool isMy;

  @override
  State<CommunityPostDetailScreen> createState() =>
      _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  @override
  void initState() {
    Get.put(PostViewController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [..._top(), AppGap.v16, _body()],
      ),
    );
  }

  List<Widget> _top() => [
    CustomBackButton(
      moreOptions: true,
      itemBuilder: (context) => [
        if (!widget.isMy)
          _topPopupItem("게시물 신고하기")
        else ...[
          _topPopupItem("게시물 수정하기"),
          _topPopupItem("게시물 삭제하기"),
        ],
      ],
    ),
    _Title(title: "요즘 UI UX", tags: ["#UI/UX", "#FrontEnd"]),
  ];

  Widget _body() => Padding(
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        _Body(),
      ],
    ),
  );

  PopupMenuEntry<String> _topPopupItem(String title) => PopupMenuItem(
    padding: AppPadding.popupManuButton,
    child: Center(child: Text(title)),
  );
}

class _Title extends StatelessWidget {
  const _Title({required this.title, required this.tags});

  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleBold20(textColor: AppColors.gray90),
          ),
          AppGap.v16,
          Row(
            spacing: AppSpacing.s16,
            children: tags
                .map(
                  (tag) => Text(
                    tag,
                    style: AppTextStyles.caption(textColor: AppColors.gray60),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body();

  final String author = "김유찬";
  final Duration postAt = Duration(minutes: 4);
  final String bodyText = """요즘 UI·UX 이슈 보면, 기술은 엄청 발전했는데 사용자 입장은 좀 
애매해짐. AI 추천이니 자동 생성이니 많아졌는데, 솔직히 왜 그게 뜨는지 모르겠음. 내가 선택한 건지, 그냥 떠밀린 건지 경계가 흐려짐.

개인화도 마찬가지임. 처음엔 편한데 쓰다 보면 피곤함. 설정 건드릴 
여지도 없고, 앱이 “너 이거 좋아하잖아” 하고 단정 짓는 느낌 듦. 다크 
패턴은 말할 것도 없고, 가입은 한 번에 되는데 탈퇴는 왜 이렇게 
숨겨놓는지 아직도 이해 안 감.

접근성도 형식만 맞춘 경우 많음. 체크리스트는 통과했는데 실제로 써보면 불편함. 애니메이션, 효과 잔뜩 넣은 UI도 처음엔 와 소리 나오는데, 정보 찾으려면 오히려 방해됨.

결국 요즘 UX 문제는 기술 부족이 아니라 태도 문제 같음. 사용자를 배려한다면서 사실은 컨트롤하려는 설계. 이제는 “얼마나 오래 쓰게 만드나” 말고 “얼마나 덜 스트레스 받게 하나”로 가야 하지 않나 싶음.""";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _top(),
        AppGap.v16,
        _content(),
        AppGap.v16,
        _buttonList(),
      ],
    );
  }

  Widget _top() => DefaultTextStyle(
    style: AppTextStyles.caption(textColor: AppColors.gray60),
    child: Row(
      children: [
        CustomProfileCircle(radius: AppSpacing.s24),
        AppGap.h12,
        Expanded(child: Text(author)),
        Text("${postAt.inMinutes}분전"),
      ],
    ),
  );

  Widget _content() => Text(
    bodyText,
    style: AppTextStyles.textMedium(textColor: AppColors.gray90),
    textAlign: .start,
  );

  Widget _buttonList() => Row(
    spacing: AppSpacing.s16,
    children: [
      CommunityCustomIconButton(
        imagePath: AppIcon.heart.path,
        action: (isSelect, total) {},
        activeColor: AppColors.red,
        total: 12,
      ),
      CommunityCustomIconButton(
        imagePath: AppIcon.bookmark.path,
        action: (isSelect, total) {},
        activeColor: AppColors.yellow,
        total: 12,
        initialSelect: true,
      ),
    ],
  );
}
