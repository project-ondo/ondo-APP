import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/post/base_post_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';

@immutable
class HomeRecommendPostList extends BasePostGrid {
  final List<Map<String, dynamic>> posts;

  HomeRecommendPostList({super.key, super.title = "추천 게시물"})
    : posts = [
        for (int i = 0; i < 5; i++) ...{{}, {}, {}},
      ];

  @override
  List<Widget> listBuilder() {
    return List.generate(posts.length, (index) {
      return PostItem(
        skills: ["UI/UX", "FrontEnd"],
        title: "요즘 UI UX",
        author: "김유찬",
        bookmarks: 12,
        favorites: 12,
        createMinutes: 4,
      );
    });
  }
}
