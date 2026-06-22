import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/notification_type.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/notification/controllers/notification_controller.dart';

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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.viewNotificationList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.viewNotificationList.isEmpty) {
                  return _ErrorView(
                    message: controller.errorMessage.value,
                    onRetry: controller.refresh,
                  );
                }

                if (controller.viewNotificationList.isEmpty) {
                  return _EmptyView();
                }

                return _NotificationList();
              }),
            ),
            AppGap.v16,
          ],
        ),
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

class _NotificationList extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          controller.loadMore();
        }
        return false;
      },
      child: Obx(
        () => ListView.separated(
          itemCount: controller.viewNotificationList.length +
              (controller.isLoadingMore.value ? 1 : 0),
          separatorBuilder: (_, _) => AppGap.v16,
          itemBuilder: (context, index) {
            if (index == controller.viewNotificationList.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final notification = controller.viewNotificationList[index];
            return notification.type == NotificationType.reportReceived
                ? ReportNotificationCard(
                    notification: notification,
                    onTap: () => controller.read(notification),
                  )
                : NotificationCard(
                    notification: notification,
                    onTap: () => controller.read(notification),
                  );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 153),
        Image.asset(AppIcon.message.path),
        Text(
          "지금은 알려드릴 게 없어요",
          style: AppTextStyles.textMedium(textColor: AppColors.gray60),
        ),
        const Spacer(flex: 275),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) =>
      AppErrorState(message: message, onRetry: onRetry);
}
