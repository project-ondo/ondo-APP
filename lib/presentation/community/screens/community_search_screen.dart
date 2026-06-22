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
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class CommunitySearchScreen extends GetView<CommunityResultController> {
  const CommunitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final error = controller.errorMessage.value;
        final hasPosts = controller.viewPosts.isNotEmpty;

        if (!hasPosts) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppPadding.screenHorizontal,
                child: Text(
                  "게시물 검색 결과",
                  style: AppTextStyles.titleSm16(),
                ),
              ),
              AppGap.v16,
              Expanded(
                child: isLoading
                    ? const AppLoadingIndicator()
                    : error.isNotEmpty
                        ? AppErrorState(
                            message: error,
                            onRetry: () => Get.find<CommunityController>()
                                .search(controller.currentQuery),
                          )
                        : const AppEmptyState(
                            message: '검색된 게시물이 없어요.\n다른 키워드로 검색해 보세요.',
                            icon: AppIcon.communityUnSelect,
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
              Get.find<CommunityController>().loadMoreSearchResults();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppGap.v16,
                PostGridList(
                  title: "게시물 검색 결과",
                  isLoading: isLoading,
                  emptyMessage: '검색된 게시물이 없어요.\n다른 키워드로 검색해 보세요.',
                  list: controller.viewPosts
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
