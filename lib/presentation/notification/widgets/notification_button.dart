import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';
import 'package:ondo/presentation/notification/screens/notification_screen.dart';

@immutable
class NotificationButton extends GetView<NotificationController> {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        child: Badge.count(
          padding: AppPadding.alertCount,
          backgroundColor: AppColors.deepRed,
          count: controller.newNotificationCount.value,
          alignment: Alignment(0.28, -0.58),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gray20,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.baseRadius),
              minimumSize: Size.square(AppSpacing.s44),
            ),
            onPressed: controller.newNotificationCount.value > 0
                ? () => Get.to(
                    NotificationScreen(),
                  )
                : null,
            icon: SvgPicture.asset(
              controller.newNotificationCount.value > 0
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
