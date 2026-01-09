import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/controllers/home_alert_controller.dart';

@immutable
class HomeTopBar extends StatelessWidget {

  const HomeTopBar({super.key});

  final double height = 44.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: height,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.gray20,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.search, color: AppColors.gray60, size: 14.2,),
                    ),

                    Text("게시물 또는 프로필 검색어를 입력해 주세요", style: AppTextStyles.textMedium(textColor: AppColors.gray60),),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: HomeAlertButton(size: height,),
          ),
        ],
      ),
    );
  }
}

@immutable
class HomeAlertButton extends StatelessWidget {
  final double _size;

  HomeAlertButton({super.key, required final double size}) : _size = size;

  final HomeAlertController alertController = Get.put(HomeAlertController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox.expand(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Obx(
                    () => Icon(
                  Icons.add_alert,
                  size: 24,
                  color: alertController.enable.value
                      ? AppColors.primaryDark
                      : AppColors.gray40,
                ),
              ),
            ),

            Positioned(
              top: 9,
              right: 5,
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
