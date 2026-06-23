import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/app_empty_state.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_profile_list.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class HomeSearchScreen extends GetView<HomeSearchResultController> {
  const HomeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final error = controller.errorMessage.value;
        final hasPosts = controller.viewPostList.isNotEmpty;
        final hasUsers = controller.viewUserList.isNotEmpty;
        final hasData = hasPosts || hasUsers;

        if (!hasData) {
          return Column(
            children: [
              Expanded(
                child: _Section(
                  title: "프로필 검색 결과",
                  titleStyle: AppTextStyles.titleBold16(),
                  child: isLoading
                      ? const AppLoadingIndicator()
                      : error.isNotEmpty
                          ? AppErrorState(
                              message: error,
                              onRetry: () => Get.find<HomeController>()
                                  .search(controller.currentQuery),
                            )
                          : const AppEmptyState(
                              message: '검색된 유저가 없어요.\n다른 키워드로 검색해 보세요.',
                              icon: AppIcon.userUnSelect,
                            ),
                ),
              ),
              Expanded(
                child: _Section(
                  title: "게시물 검색 결과",
                  titleStyle: AppTextStyles.titleSm16(),
                  child: isLoading
                      ? const AppLoadingIndicator()
                      : error.isNotEmpty
                          ? AppErrorState(
                              message: error,
                              onRetry: () => Get.find<HomeController>()
                                  .search(controller.currentQuery),
                            )
                          : const AppEmptyState(
                              message: '검색된 게시물이 없어요.\n다른 키워드로 검색해 보세요.',
                              icon: AppIcon.communityUnSelect,
                            ),
                ),
              ),
            ],
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth == 0 &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 200) {
              Get.find<HomeController>().loadMoreSearchResults();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppGap.v16,
                HomeProfileList(
                  title: "프로필 검색 결과",
                  controller: controller,
                  isLoadingMore: controller.isLoading,
                  emptyMessage: '검색된 유저가 없어요.\n다른 키워드로 검색해 보세요.',
                  errorMessage: controller.errorMessage,
                  onRetry: () => Get.find<HomeController>()
                      .search(controller.currentQuery),
                ),
                AppGap.v16,
                PostGridList(
                  title: "게시물 검색 결과",
                  isLoading: isLoading,
                  errorMessage: error,
                  emptyMessage: '검색된 게시물이 없어요.\n다른 키워드로 검색해 보세요.',
                  onRetry: () => Get.find<HomeController>()
                      .search(controller.currentQuery),
                  list: controller.viewPostList
                      .map((post) => PostItem(post: post, isMy: true))
                      .toList(),
                ),
                AppGap.v16,
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final Widget child;

  const _Section({
    required this.title,
    required this.titleStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.screenHorizontal,
          child: Text(title, style: titleStyle),
        ),
        AppGap.v16,
        Expanded(child: child),
      ],
    );
  }
}
