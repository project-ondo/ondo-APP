import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/domain/entities/notification/notification_entity.dart';
import 'package:ondo/domain/usecases/notification/delete_all_read_notifications_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_my_notification_list_use_case.dart';
import 'package:ondo/domain/usecases/notification/load_unread_notification_count_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_all_notification_use_case.dart';
import 'package:ondo/domain/usecases/notification/read_notification_use_case.dart';

class NotificationController extends GetxController {
  static const pageSize = 11;

  final RxList<NotificationEntity> viewNotificationList =
      <NotificationEntity>[].obs;

  final RxInt newNotificationCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPageIndex = 0.obs;
  final RxInt totalPages = 1.obs;
  final RxInt loadedPages = 0.obs;
  final RxInt totalElements = 0.obs;

  final LoadMyNotificationListUseCase loadMyNotificationListUseCase;
  final LoadUnreadNotificationCountUseCase loadUnreadNotificationCountUseCase;
  final ReadAllNotificationUseCase readAllNotificationUseCase;
  final ReadNotificationUseCase readNotificationUseCase;
  final DeleteAllReadNotificationsUseCase deleteAllReadNotificationsUseCase;

  NotificationController({
    required this.loadMyNotificationListUseCase,
    required this.loadUnreadNotificationCountUseCase,
    required this.readAllNotificationUseCase,
    required this.readNotificationUseCase,
    required this.deleteAllReadNotificationsUseCase,
  });

  @override
  void onInit() {
    refresh();
    super.onInit();
  }

  @override
  Future<void> refresh() async {
    await _loadMyNotificationList();
    await _loadUnreadNotificationCount();
  }

  Future<void> _loadMyNotificationList() async {
    isLoading.value = true;
    currentPageIndex.value = 0;

    try {
      final result = await loadMyNotificationListUseCase.call(
        size: pageSize,
        page: 0,
      );

      viewNotificationList.assignAll(result.content);
      totalPages.value = result.totalPages > 0 ? result.totalPages : 1;
      loadedPages.value = 1;
      totalElements.value = result.totalElements;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    final page = currentPageIndex.value;

    if (isLoadingMore.value || page >= totalPages.value) return;

    isLoadingMore.value = true;

    try {
      final result = await loadMyNotificationListUseCase.call(
        size: pageSize,
        page: page,
      );

      viewNotificationList.addAll(result.content);
      loadedPages.value++;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadUnreadNotificationCount() async {
    newNotificationCount.value = await loadUnreadNotificationCountUseCase();
  }

  Future<void> _readAllNotification() async {
    await readAllNotificationUseCase();
  }

  Future<bool> _readNotification(int id) async {
    return await readNotificationUseCase(id);
  }

  Future<bool> _deleteAllReadNotification() async {
    return deleteAllReadNotificationsUseCase();
  }

  Future<void> read(NotificationEntity notification) async {
    if (notification.read) return;

    if (await _readNotification(notification.id)) {
      final index = viewNotificationList.indexWhere(
        (e) => e.id == notification.id,
      );
      if (index >= 0) {
        viewNotificationList[index] = notification.copyWith(read: true);
      }
    }
  }

  Future<void> readAll() async {
    await _readAllNotification();
    viewNotificationList.assignAll(
      viewNotificationList.map((e) => e.copyWith(read: true)).toList(),
    );
    newNotificationCount.value = 0;
  }

  Future<void> deleteAllNotification(BuildContext context) async => showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: "알림",
      comment: "정말 모든 알림을 삭제하시겠어요?",
      actionLeft: () => context.pop(),
      actionRight: () async {
        if (await _deleteAllReadNotification()) {
          final removedCount = viewNotificationList
              .where((notification) => notification.read == true)
              .length;

          viewNotificationList.removeWhere(
            (notification) => notification.read == true,
          );

          totalElements.value -= removedCount;
        }
        context.pop();
      },
      rightActionText: "삭제",
    ),
  );
}
