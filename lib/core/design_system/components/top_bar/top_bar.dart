import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/top_bar_alert_controller.dart';

@immutable
class TopBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final TopBarAlertController _alertController = Get.put(
    TopBarAlertController(),
  );

  TopBar({super.key});

  final double _alertSize = 44.0;
  final double _textFieldSize = 320;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _textFieldSize,
          height: _alertSize,
          child: CustomTextField(
            controller: _searchController,
            hintText: "게시물 또는 프로필 검색어를 입력해 주세요",
            prefix: SvgPicture.asset(AppIcon.searchFocus.path),
          ),
        ),

        Spacer(),

        _AlertButton(
          size: _alertSize,
        ),
      ],
    );
  }
}

@immutable
class _AlertButton extends StatelessWidget {
  final TopBarAlertController alertController =
      Get.find<TopBarAlertController>();

  final double size;

  _AlertButton({
    required this.size,
  });

  final double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Obx(
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
              ),
            ),

            Positioned(
              top: size * 0.2,
              right: size * 0.2,
              child: Obx(
                () => Container(
                  padding: EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${alertController.totals.value}",
                    style: AppTextStyles.captionSmall(
                      textColor: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
