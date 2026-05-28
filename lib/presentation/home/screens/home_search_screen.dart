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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppGap.v16,
            HomeProfileList(
              title: "프로필 검색 결과",
              controller: controller,
            ),

            AppGap.v16,
            Obx(
              () => PostGridList(
                title: "게시물 검색 결과",
                list: controller.viewPostList
                    .map(
                      (post) => PostItem(
                        postId: post.postId,
                        skills: post.tags,
                        title: post.title,
                        author: post.authorName,
                        bookmarks: post.likeCount,
                        favorites: post.likeCount,
                        createAt: post.createAt,
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
    );
  }
}
