import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/notification/states/notification_state.dart';

import '../widgets/notification_card.dart';
import '../widgets/report_notification_card.dart';

@immutable
class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  void _showNotificationDeleteDialog() => Get.dialog(
    CustomAlertDialog(
      title: "알림",
      comment: "정말 모든 알림을 삭제하시겠어요?",
      actionLeft: () => Get.back(),
      actionRight: () {
        controller.clear();
        Get.back();
      },
      rightActionText: "삭제",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _topBar() => CustomBackButton(
    moreOptions: true,
    itemBuilder: (context) => [
      PopupMenuItem(
        padding: AppPadding.popupManuButton,
        onTap: _showNotificationDeleteDialog,
        height: double.minPositive,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "읽은 알림 모두 삭제",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
      ),
    ],
  );

  Widget _body() => Container(
    color: AppColors.background,
    child: Column(
      children: [
        _Title(),

        Obx(
          () => Expanded(
            child: controller.viewNotificationList.isNotEmpty
                ? _NotificationPageList()
                : _noMessageIcon(),
          ),
        ),
      ],
    ),
  );

  Widget _noMessageIcon() => Column(
    children: [
      Spacer(
        flex: 153,
      ),
      Image.asset(AppIcon.message.path),
      Text(
        "지금은 알려드릴 게 없어요",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
      Spacer(
        flex: 275,
      ),
    ],
  );
}

class _Title extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.screenHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppGap.v8,
          Row(
            children: [
              Text(
                "알림",
                style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
              ),
              AppGap.h12,
              Obx(
                () => Text(
                  "${controller.viewNotificationList.length}",
                  style: AppTextStyles.textMedium(textColor: AppColors.gray60),
                ),
              ),
            ],
          ),
          AppGap.v16,
        ],
      ),
    );
  }
}

@immutable
class _NotificationPageList extends GetView<NotificationController> {
  final ValueNotifier<int> curIndex = ValueNotifier(0);

  int getTotalPage() => (controller.viewNotificationList.length / 11).ceil();

  int getStartIndex(int index) => index * 11;

  int getLastIndex(int index) =>
      min(getStartIndex(index) + 11, controller.viewNotificationList.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.screenHorizontal,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: getTotalPage(),
              onPageChanged: (value) => curIndex.value = value,
              itemBuilder: (context, index) =>
                  _notificationList(getStartIndex(index), getLastIndex(index)),
            ),
          ),
          AppGap.v16,
          _indicator(),
        ],
      ),
    );
  }

  Widget _notificationList(int startIndex, int lastIndex) {
    final subNotifications = controller.viewNotificationList.sublist(
      startIndex,
      lastIndex,
    );
    return ListView.separated(
      shrinkWrap: true,
      itemCount: subNotifications.length,
      itemBuilder: (context, index) {
        final notification = subNotifications[index];

        if (notification.type == NotificationState.reported.title) {
          return ReportNotificationCard(
            notificationInfo: notification,
          );
        }

        return NotificationCard(
          notificationInfo: notification,
        );
      },
      separatorBuilder: (context, index) => AppGap.v16,
    );
  }

  Widget _indicator() => ValueListenableBuilder(
    valueListenable: curIndex,
    builder: (_, _, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          (controller.viewNotificationList.length / 11).ceil(),
          (index) => Padding(
            padding: AppPadding.indicatorSpacing,
            child: Text(
              "${index + 1}",
              style: AppTextStyles.pageIndicator(
                isCurrent: curIndex.value == index,
              ),
            ),
          ),
        ),
      );
    },
  );
}
