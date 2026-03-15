import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/alert/controllers/alert_controller.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/alert/screens/alert_screen.dart';
import 'package:ondo/presentation/search/states/search_state.dart';
import 'package:ondo/presentation/search/widgets/search_popup.dart';

typedef HomeSearchModel = ({
  List<Map<String, dynamic>> chats,
  List<Map<String, dynamic>> posts,
});
typedef CommunitySearchModel = ({
  List<Map<String, dynamic>> posts,
});
typedef ChatSearchModel = ({
  List<Map<String, dynamic>> chats,
});

@immutable
class MainTopSearchBar extends StatefulWidget {
  final Widget mainPage;
  final String pageId;
  final Widget? Function(SearchState state) resultPageBuilder;

  const MainTopSearchBar({
    super.key,
    required this.mainPage,
    required this.resultPageBuilder,
    required this.pageId,
  });

  @override
  State<MainTopSearchBar> createState() => _MainTopSearchBarState();
}

class _MainTopSearchBarState extends State<MainTopSearchBar> {
  late final MainTopBarSearchController _controller;

  @override
  void initState() {
    Get.put(AlertController());
    _controller = Get.put(MainTopBarSearchController(), tag: widget.pageId);
    Get.lazyPut(() => SearchPopupController(mainController: _controller));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appBar(),
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _controller.searchUnfocus,
                child: Obx(() {
                  if (!_controller.showResult.value) return widget.mainPage;

                  final res = widget.resultPageBuilder(_controller.state);

                  //검색 결과가 없다면 null을 반환해 mainPage 표시
                  if (res == null) {
                    _controller.showResult.value = false;
                    _controller.textController.clear();
                    return widget.mainPage;
                  }

                  return res;
                }),
              ),
              Obx(() {
                if (!_controller.showPopup.value) {
                  return SizedBox.shrink();
                }

                return SearchPopup(
                  pageId: widget.pageId,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      padding: AppPadding.topBar,
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              onSubmitted: _controller.onSubmitText,
              onChanged: _controller.onChange,
              focusNode: _controller.focusNode,
              controller: _controller.textController,
              hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
              maxLines: 1,
              prefix: SvgPicture.asset(AppIcon.searchFocus.path),
            ),
          ),
          Obx(() {
            if (_controller.showPopup.value) {
              return SizedBox.shrink();
            }
            return Row(
              children: [
                AppGap.h16,
                _AlertButton(),
              ],
            );
          }),
        ],
      ),
    );
  }
}

@immutable
class _AlertButton extends GetView<AlertController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        child: Badge.count(
          padding: AppPadding.alertCount,
          backgroundColor: AppColors.deepRed,
          count: controller.total.value,
          alignment: Alignment(0.28, -0.58),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gray20,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.baseRadius),
              minimumSize: Size.square(AppSpacing.s44),
            ),
            onPressed: controller.enable.value
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlertScreen(),
                    ),
                  )
                : null,
            icon: SvgPicture.asset(
              controller.enable.value
                  ? AppIcon.alarmBrown.path
                  : AppIcon.alarmGrey.path,
              height: AppSpacing.s16,
              width: AppSpacing.s16,
            ),
          ),
        ),
      ),
    );
  }
}
