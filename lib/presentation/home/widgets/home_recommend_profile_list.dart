import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/components/app_empty_state.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

class HomeProfileList extends StatelessWidget {
  const HomeProfileList({
    super.key,
    required this.title,
    required this.controller,
    this.onEndReached,
    this.isLoadingMore,
    this.emptyMessage = '추천 유저가 없어요.',
    this.errorMessage,
    this.onRetry,
  });

  final String title;
  final BaseHomeController controller;
  final VoidCallback? onEndReached;
  final RxBool? isLoadingMore;
  final String emptyMessage;
  final RxString? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPadding.screenHorizontal,
            child: Text(
              title,
              style: AppTextStyles.titleBold16(),
            ),
          ),
          AppGap.v16,
          Expanded(child: _profileList()),
        ],
      ),
    );
  }

  Widget _profileList() {
    return Obx(() {
      final users = controller.viewUserList;
      final loadingMore = isLoadingMore?.value ?? false;
      final error = errorMessage?.value ?? '';

      if (loadingMore && users.isEmpty) {
        return const AppLoadingIndicator();
      }
      if (error.isNotEmpty && users.isEmpty) {
        return AppErrorState(message: error, onRetry: onRetry);
      }
      if (users.isEmpty) {
        return AppEmptyState(
          message: emptyMessage,
          icon: AppIcon.userUnSelect,
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 100) {
            onEndReached?.call();
          }
          return false;
        },
        child: ListView.separated(
          padding: AppPadding.screenHorizontal,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => AppGap.h16,
          itemBuilder: (context, index) {
            final chat = users[index];
            return HomeProfileCard(
              publicId: chat.publicId,
              skill: chat.interests.firstOrNull ?? '',
              name: chat.displayName,
              rating: chat.ratingCount,
            );
          },
          itemCount: users.length,
        ),
      );
    });
  }
}
