import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_profile_list.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

import '../../../core/design_system/app_layout.dart';

class HomeSearchScreen extends GetView<HomeSearchResultController> {
  const HomeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: NotificationListener<ScrollNotification>(
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
              ),
              AppGap.v16,
              Obx(
                () => PostGridList(
                  title: "게시물 검색 결과",
                  isLoading: controller.isLoading.value,
                  emptyMessage: '검색된 게시물이 없어요.\n다른 키워드로 검색해 보세요.',
                  list: controller.viewPostList
                      .map(
                        (post) => PostItem(
                          post: post,
                          isMy: true,
                        ),
                      )
                      .toList(),
                ),
              ),
              AppGap.v16,
            ],
          ),
        ),
      ),
    );
  }
}
