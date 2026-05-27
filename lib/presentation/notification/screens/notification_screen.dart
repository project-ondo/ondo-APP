import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/notification/states/notification_state.dart';

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
        onTap: controller.deleteAllNotification,
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
    color: AppColors.white,
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        _Title(),
        AppGap.v16,
        Obx(
          () => Expanded(
            child: controller.viewNotificationList.isNotEmpty
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
                "${controller.viewNotificationList.length}",
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
  final ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final list = controller.viewNotificationList;
    final pageCount = (list.length / 11).ceil();
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: pageCount,
            onPageChanged: (value) => curIndex.value = value,
            itemBuilder: (context, pageIndex) {
              final slice = list.sublist(
                pageIndex * 11,
                min((pageIndex + 1) * 11, list.length),
              );

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: slice.length,
                separatorBuilder: (context, index) => AppGap.v16,
                itemBuilder: (context, index) {
                  final notification = slice[index];
                  if (notification.type == NotificationState.reported.title) {
                    return ReportNotificationCard(
                      notificationInfo: notification,
                    );
                  }
                  return NotificationCard(
                    notificationInfo: notification,
                  );
                },
              );
            },
          ),
        ),
        AppGap.v16,
        ValueListenableBuilder(
          valueListenable: curIndex,
          builder: (_, _, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageCount,
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
        ),
        AppGap.v16,
      ],
    );
  }
}
