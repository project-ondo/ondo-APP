import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/post/widgets/indicator_post_page_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class CommunityPostList extends GetView<CommunityController> {
  const CommunityPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.viewPostList.isEmpty) {
        return const AppLoadingIndicator();
      }
      if (controller.errorMessage.value.isNotEmpty &&
          controller.viewPostList.isEmpty) {
        return AppErrorState(
          message: controller.errorMessage.value,
          onRetry: () => controller.loadRecommendPostList(refresh: true),
        );
      }
      return IndicatorPostPageList(
        title: controller.selectTagList.isEmpty ? "게시물 목록" : "태그 분류 결과",
        isLoading: controller.isLoading.value,
        emptyMessage: '아직 게시물이 없어요.\n첫 번째 게시물을 작성해 보세요!',
        items: List.generate(
          controller.viewPostList.length,
          (index) {
            final post = controller.viewPostList[index];
            return PostItem(
              key: ValueKey(post.postId),
              post: post,
              isMy: true,
              heartAction: (isLiked, total) {
                controller.toggleLike(post.postId, isLiked);
              },
            );
          },
        ),
        itemFloors: 4,
        onLastPage: () => controller.loadRecommendPostList(),
      );
    });
  }
}
