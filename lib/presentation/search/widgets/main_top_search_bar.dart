import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/notification/widgets/notification_button.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/search/states/search_page_state.dart';
import 'package:ondo/presentation/search/states/search_state.dart';
import 'package:ondo/presentation/search/widgets/search_popup.dart';

@immutable
class MainTopSearchBar extends StatefulWidget {
  final Widget mainPage;
  final SearchPageState pageState;
  final Widget? Function(SearchState state) resultPageBuilder;

  const MainTopSearchBar({
    super.key,
    required this.mainPage,
    required this.resultPageBuilder,
    required this.pageState,
  });

  @override
  State<MainTopSearchBar> createState() => _MainTopSearchBarState();
}

class _MainTopSearchBarState extends State<MainTopSearchBar> {
  late final MainTopBarSearchController controller;

  @override
  void initState() {
    controller = Get.find<MainTopBarSearchController>(tag: widget.pageState.id);
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
                onTap: controller.tapSearchBar,
                child: Obx(() {
                  if (!controller.showResult.value) return widget.mainPage;

                  final resultPage = widget.resultPageBuilder(controller.state);

                  controller.showResult.value = false;
                  controller.state.clear();
                  //검색 결과가 없다면 null을 반환해 mainPage 표시
                  return resultPage ?? widget.mainPage;
                }),
              ),
              Obx(() {
                if (!controller.showPopup.value) {
                  return SizedBox.shrink();
                }

                return SearchPopup(
                  pageId: widget.pageState.id,
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
              onSubmitted: (value) => controller.submit(query: value),
              focusNode: controller.focusNode,
              controller: controller.searchController,
              hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
              maxLines: 1,
              prefix: SvgPicture.asset(AppIcon.searchFocus.path),
            ),
          ),
          Obx(() {
            if (controller.showPopup.value) {
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
