import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/widgets/indicator_post_page_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class CommunityRelatedPostList extends GetView<PostViewController> {
  const CommunityRelatedPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IndicatorPostPageList(
        title: "관련 게시물",
        items: controller.postList.map((post) {
          return PostItem(
            skills: post.skills,
            title: post.title,
            author: post.name,
            bookmarks: post.bookmarks,
            favorites: post.favoites,
            createMinutes: post.createAt.inMinutes,
          );
        }).toList(),
      ),
    );
  }
}
