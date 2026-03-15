import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/post/base_post_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/community/widgets/community_post_add_button.dart';

class CommunitySearchPage extends StatelessWidget {
  const CommunitySearchPage({super.key});

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
  final CommunitySearchResultController _controller =
      Get.find<CommunitySearchResultController>();

  _PostResults({
    super.title = "게시물 검색 결과",
  });

  @override
  List<Widget> listBuilder() {
    return List.generate(_controller.posts.length, (index) {
      return Obx(() {
        final post = _controller.posts[index];
        return PostItem(
          skills: post.skills,
          title: post.title,
          author: post.name,
          bookmarks: post.bookmarks,
          favorites: post.favoites,
          createMinutes: post.createAt.inMinutes,
        );
      });
    });
  }
}
