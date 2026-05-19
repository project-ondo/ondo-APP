import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/notification/widgets/notification_button.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/search/widgets/search_popup.dart';

@immutable
class MainTopSearchBar extends StatefulWidget {
  const MainTopSearchBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<MainTopSearchBar> createState() => _MainTopSearchBarState();
}

class _MainTopSearchBarState extends State<MainTopSearchBar> {
  late final MainTopBarSearchController controller;

  @override
  void initState() {
    //TODO : 공통 widget으로 변환
    controller = Get.put(MainTopBarSearchController());
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
                onTap: controller.unfocusSearchBar,
                child: widget.child,
              ),
              Obx(() {
                if (controller.showPopup.value) {
                  return SearchPopup();
                }
                return SizedBox.shrink();
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
            child: GestureDetector(
              onTap: controller.focusSearchBar,
              child: CustomTextField(
                onSubmitted: (value) {
                  controller.onSubmit(context, keyword: value);
                },
                onChanged: controller.onChange,
                controller: controller.searchController,
                hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
                maxLines: 1,
                prefix: SvgPicture.asset(AppIcon.searchFocus.path),
              ),
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
