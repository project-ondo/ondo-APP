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
                  items: controller.relatedPostList.map((post) {
          return PostItem(
            post: post,
            isMy: true,
          );
                  }).toList(),
                ),
    );
  }
}