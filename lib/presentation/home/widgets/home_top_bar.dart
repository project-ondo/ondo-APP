import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/home/controllers/home_alert_controller.dart';

@immutable
class HomeTopBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final HomeAlertController _alertController = Get.put(HomeAlertController());

  HomeTopBar({super.key});

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

        HomeAlertButton(
          size: _alertSize,
          alertController: _alertController,
        ),
      ],
    );
  }
}

@immutable
class HomeAlertButton extends StatelessWidget {
  final HomeAlertController alertController;
  final double size;

  HomeAlertButton({
    super.key,
    required this.size,
    required this.alertController,
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
              top: 11,
              right: 7,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
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
