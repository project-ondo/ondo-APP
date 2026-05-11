import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/widgets/indicator_post_page_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class RelatedPostList extends GetView<PostViewController> {
  const RelatedPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IndicatorPostPageList(
        title: "관련 게시물",
        items: controller.postList.map((post) {
          return PostItem(
            postId: post.postId,
            skills: post.tags,
            title: post.title,
            author: post.authorName,
            bookmarks: post.bookmarkCount,
            favorites: post.likeCount,
            createAt: post.createAt,
            isMy: true, //TODO: Store에서 현재 유저 ID와 비교하여 설정
          );
        }).toList(),
      ),
    );
  }
}
