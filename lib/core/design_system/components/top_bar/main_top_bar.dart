import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/alert/controllers/alert_controller.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/core/design_system/components/top_bar/search_popup.dart';
import 'package:ondo/presentation/alert/screens/alert_screen.dart';

@immutable
class MainTopBar extends StatelessWidget {
  final Widget child;

  MainTopBar({super.key, required this.child}) {
    Get.put(AlertController());
  }

  final MainTopBarSearchController _topBarSearchController = Get.put(
    MainTopBarSearchController(),
  );
  final double _height = 44.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            topBar(),
            GestureDetector(
              onTap: _topBarSearchController.onOtherTap,
              child: child,
            ),
          ],
        ),

        Obx(
          () {
            if (!_topBarSearchController.isShowPopUp.value) {
              return SizedBox.shrink();
            }
            return Positioned(
              top: _height + AppPadding.topBar.vertical,
              child: SearchPopup(),
            );
          },
        ),
      ],
    );
  }

  Widget topBar() {
    return Container(
      padding: AppPadding.topBar,
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: _height,
              child: CustomTextField(
                focusNode: _topBarSearchController.focusNode,
                onChanged: _topBarSearchController.onTyping,
                controller: _topBarSearchController.searchTextController,
                hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
                prefix: SvgPicture.asset(AppIcon.searchFocus.path),
              ),
            ),
          ),

          Obx(() {
            if (_topBarSearchController.isShowPopUp.value) return SizedBox.shrink();
            return Row(
              children: [
                AppGap.h16,
                _AlertButton(size: _height),
              ],
            );
          }),
        ],
      ),
    );
  }
}

@immutable
class _AlertButton extends StatelessWidget {
  final double size;

  _AlertButton({
    required this.size,
  });

  final AlertController alertController =
      Get.find<AlertController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlertScreen(),
        ),
      ),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.gray20,
          borderRadius: AppRadius.baseRadius,
        ),
        child: SizedBox.expand(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: _alertIcon(),
              ),

              Positioned(
                top: size * 0.2,
                right: size * 0.2,
                child: _alertCount(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final double _iconSize = 16;

  Widget _alertIcon() {
    return Obx(
      () => alertController.enable.value
          ? SvgPicture.asset(
              AppIcon.alarmBrown.path,
              height: _iconSize,
              width: _iconSize,
            )
          : SvgPicture.asset(
              AppIcon.alarmGrey.path,
              height: _iconSize,
              width: _iconSize,
            ),
    );
  }

  Widget _alertCount() {
    return Obx(
      () => Container(
        padding: AppPadding.alertCount,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: AppRadius.alertRadius,
        ),
        child: Text(
          "${alertController.total.value}",
          style: AppTextStyles.captionSmall(
            textColor: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
