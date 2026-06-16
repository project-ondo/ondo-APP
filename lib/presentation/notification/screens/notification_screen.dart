import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/notification_type.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

import '../widgets/notification_card.dart';
import '../widgets/report_notification_card.dart';

@immutable
class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _topBar() => CustomBackButton(
    moreOptions: true,
    itemBuilder: (context) => [
      PopupMenuItem(
        padding: AppPadding.popupManuButton,
        onTap: () => controller.deleteAllNotification(context),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "읽은 알림 모두 삭제",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
      ),
      PopupMenuItem(
        padding: AppPadding.popupManuButton,
        onTap: controller.readAll,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "전체 알림 모두 읽기",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
      ),
    ],
  );

  Widget _body() => Container(
    color: AppColors.white,
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        _Title(),
        AppGap.v16,
        Obx(
          () => Expanded(
            child:
                controller.isLoading.value &&
                    controller.viewNotificationList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : controller.viewNotificationList.isNotEmpty
                ? _NotificationPageList()
                : _noMessageIcon(),
          ),
        ),
        AppGap.v16,
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
    return Column(
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
                "${controller.totalElements.value}",
                style: AppTextStyles.textMedium(textColor: AppColors.gray60),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

@immutable
class _NotificationPageList extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    final list = controller.viewNotificationList;
    final pageTotal = controller.totalPages.value;
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: pageTotal,
            onPageChanged: (value) {
              controller.currentPageIndex.value = value;
            },
            itemBuilder: (context, pi) {
              if (pi >= controller.loadedPages.value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.loadMore();
                });
                return const Center(child: CircularProgressIndicator());
              }

              final start = min(
                pi * NotificationController.pageSize,
                list.length,
              );
              final slice = list.sublist(
                start,
                min(
                  start + NotificationController.pageSize,
                  list.length,
                ),
              );

              return Column(
                children: [
                  for (var index = 0; index < slice.length; index++) ...[
                    if (index > 0) AppGap.v16,
                    slice[index].type == NotificationType.reportReceived
                        ? ReportNotificationCard(
                            notification: slice[index],
                            onTap: () => controller.read(slice[index]),
                          )
                        : NotificationCard(
                            notification: slice[index],
                            onTap: () => controller.read(slice[index]),
                          ),
                  ],
                ],
              );
            },
          ),
        ),
        AppGap.v16,
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.totalPages.value,
              (index) => Padding(
                padding: AppPadding.indicatorSpacing,
                child: Text(
                  "${index + 1}",
                  style: AppTextStyles.pageIndicator(
                    isCurrent: controller.currentPageIndex.value == index,
                  ),
                ),
              ),
            ),
          ),
        ),
        AppGap.v16,
      ],
    );
  }
}
