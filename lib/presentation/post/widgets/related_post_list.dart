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
<<<<<<< HEAD
          () => IndicatorPostPageList(
                  title: "관련 게시물",
                  items: controller.postList.map((post) {
=======
      () => IndicatorPostPageList(
        title: "관련 게시물",
        items: controller.postList.map((post) {
>>>>>>> 4536235 (fix : 하트 기능 버그 수정)
          return PostItem(
            postId: post.postId,
            skills: post.tags,
            title: post.title,
            author: post.authorName,
            bookmarks: 0,
            favorites: post.likeCount,
            createAt: DateTime.now(),
            isMy: true,
            initialFavorite: post.isFavorite,
            heartAction: (isFavorite, total) {
              controller.toggleLike(isFavorite);
            },
          );
                  }).toList(),
                ),
    );
  }
}
