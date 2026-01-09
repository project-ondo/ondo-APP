import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/presentation/home/controllers/home_alert_controller.dart';

class HomeAlertButton extends StatelessWidget {
  final _size;

  HomeAlertButton({super.key, required dynamic size}) : _size = size;

  HomeAlertController alertController = HomeAlertController();

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
