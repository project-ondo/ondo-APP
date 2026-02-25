import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/post/indicator_post_page_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';

class CommunityPostList extends StatelessWidget {
  CommunityPostList({super.key});

  final List<PostItem> posts = List.generate(
    38,
    (index) => PostItem(
      skills: ["UI/UX", "FrontEnd"],
      title: "요즘 UI UX",
      author: "김유찬",
      bookmarks: 12,
      favorites: 12,
      createMinutes: 4,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return IndicatorPostPageList(title: "게시물 목록", items: posts, itemFloors: 5);
  }
}
