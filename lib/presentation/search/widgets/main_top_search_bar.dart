import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/notification/widgets/notification_button.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/search/states/search_state.dart';
import 'package:ondo/presentation/search/widgets/search_popup.dart';

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
    _controller = Get.put(MainTopBarSearchController(), tag: widget.pageId);
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

                  _controller.showResult.value = false;
                  _controller.state.clear();
                  //검색 결과가 없다면 null을 반환해 mainPage 표시
                  return res ?? widget.mainPage;
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
                NotificationButton(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
