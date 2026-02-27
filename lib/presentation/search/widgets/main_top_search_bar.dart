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
  final Widget Function(dynamic resultModel) resultPageBuilder;
  final Type resultModelType;

  const MainTopSearchBar.home({
    super.key,
    required this.mainPage,
    required this.resultPageBuilder,
    this.resultModelType = HomeSearchModel,
  });

  const MainTopSearchBar.community({
    super.key,
    required this.mainPage,
    required this.resultPageBuilder,
    this.resultModelType = CommunitySearchModel,
  });

  const MainTopSearchBar.chat({
    super.key,
    required this.mainPage,
    required this.resultPageBuilder,
    this.resultModelType = ChatSearchModel,
  });

  @override
  State<MainTopSearchBar> createState() => _MainTopSearchBarState();
}

class _MainTopSearchBarState extends State<MainTopSearchBar> {
  late final MainTopBarSearchController _controller;

  @override
  void initState() {
    _controller = Get.put(MainTopBarSearchController());
    Get.put(AlertController());
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
                onTap: _controller.onOtherTap,
                child: Obx(() {
                  if (!_controller.showResult.value) {
                    return widget.mainPage;
                  }
                  final data = _controller.checkResultDataType(
                    widget.resultModelType,
                  );
                  if (data == null) return SizedBox.shrink();
                  return widget.resultPageBuilder(data);
                }),
              ),
              Obx(() {
                if (!_controller.showSearchPopup.value) {
                  return SizedBox.shrink();
                }
                return SearchPopup();
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
              onSubmitted: _controller.onSubmit,
              focusNode: _controller.focusNode,
              controller: _controller.textController,
              hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
              prefix: SvgPicture.asset(AppIcon.searchFocus.path),
            ),
          ),
          Obx(() {
            if (_controller.showSearchPopup.value) {
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
