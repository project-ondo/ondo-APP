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
  static const _pageSize = 20;

  final RxList<NotificationEntity> viewNotificationList =
      <NotificationEntity>[].obs;

  final RxInt newNotificationCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt totalElements = 0.obs;

  int _currentPage = 0;
  bool _isLast = false;

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
    await Future.wait([
      _loadMyNotificationList(),
      _loadUnreadNotificationCount(),
    ]);
  }

  Future<void> _loadMyNotificationList() async {
    _currentPage = 0;
    _isLast = false;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final result = await loadMyNotificationListUseCase.call(
        size: _pageSize,
        page: 0,
      );
      viewNotificationList.assignAll(result.content);
      _isLast = result.last ?? true;
      totalElements.value = result.totalElements;
      _currentPage = 1;
    } catch (e) {
      debugPrint('[NotificationController] 알림 목록 조회 실패 - error: $e');
      errorMessage.value = '알림을 불러오지 못했습니다.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLast || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await loadMyNotificationListUseCase.call(
        size: _pageSize,
        page: _currentPage,
      );
      viewNotificationList.addAll(result.content);
      _isLast = result.last ?? true;
      _currentPage++;
    } catch (e) {
      debugPrint('[NotificationController] 알림 추가 로드 실패 - error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      newNotificationCount.value = await loadUnreadNotificationCountUseCase();
    } catch (e) {
      debugPrint('[NotificationController] 읽지 않은 알림 수 조회 실패 - error: $e');
    }
  }

  Future<void> read(NotificationEntity notification) async {
    if (notification.read) return;

    try {
      if (await _readNotification(notification.id)) {
        final index = viewNotificationList.indexWhere(
          (e) => e.id == notification.id,
        );
        if (index >= 0) {
          viewNotificationList[index] = notification.copyWith(read: true);
        }
      }
    } catch (e) {
      debugPrint('[NotificationController] 알림 읽음 처리 실패 - error: $e');
    }
  }

  Future<void> readAll() async {
    try {
      await readAllNotificationUseCase();
      viewNotificationList.assignAll(
        viewNotificationList.map((e) => e.copyWith(read: true)).toList(),
      );
      newNotificationCount.value = 0;
    } catch (e) {
      debugPrint('[NotificationController] 전체 읽음 처리 실패 - error: $e');
    }
  }

  Future<void> deleteAllNotification(BuildContext context) async => showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: "알림",
          comment: "정말 모든 알림을 삭제하시겠어요?",
          actionLeft: () => context.pop(),
          actionRight: () async {
            try {
              if (await _deleteAllReadNotification()) {
                final removedCount = viewNotificationList
                    .where((n) => n.read == true)
                    .length;
                viewNotificationList.removeWhere((n) => n.read == true);
                totalElements.value -= removedCount;
              }
            } catch (e) {
              debugPrint('[NotificationController] 알림 삭제 실패 - error: $e');
            } finally {
              if (context.mounted) context.pop();
            }
          },
          rightActionText: "삭제",
        ),
      );

  Future<bool> _readNotification(int id) async =>
      readNotificationUseCase(id);

  Future<bool> _deleteAllReadNotification() async =>
      deleteAllReadNotificationsUseCase();
}
