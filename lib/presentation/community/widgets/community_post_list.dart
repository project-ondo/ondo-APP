import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/post/widgets/indicator_post_page_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class CommunityPostList extends GetView<CommunityController> {
  const CommunityPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => IndicatorPostPageList(
        title: controller.selectTagList.isEmpty ? "게시물 목록" : "태그 분류 결과",
        items: List.generate(
          controller.viewPostList.length,
              (index) {
            final post = controller.viewPostList[index];
            return PostItem(
              key: ValueKey('${post.postId}-${post.likeCount}-${post.isFavorite}'),
              post: post,
              isMy: true,
              heartAction: (isLiked, total) {
                controller.toggleLike(post.postId, isLiked);
              },
            );
          },
        ),
        itemFloors: 4,
      ),
    );
  }
}