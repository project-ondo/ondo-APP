import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppGap.v16,
            Obx(
              () => PostGridList(
                title: "게시물 검색 결과",
                list: controller.viewPosts
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
    );
  }
}
