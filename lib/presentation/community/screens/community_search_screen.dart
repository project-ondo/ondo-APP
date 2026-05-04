import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class CommunitySearchScreen extends StatelessWidget {
  const CommunitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            children: [
              AppGap.v16,
              _PostResults(),
              AppGap.v16,
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _PostResults extends BasePostGrid {
  final CommunityResultController _controller =
      Get.find<CommunityResultController>();

  _PostResults({
    super.title = "게시물 검색 결과",
  });

  @override
  List<Widget> listBuilder() {
    return List.generate(_controller.viewPosts.length, (index) {
      return Obx(() {
        final post = _controller.viewPosts[index];
        return PostItem(
          postId: post.postId,
          skills: post.skills,
          title: post.title,
          author: post.name,
          bookmarks: post.bookmarks,
          favorites: post.favorites,
          createAt: post.createAt,
          isMy: true,
        );
      });
    });
  }
}
