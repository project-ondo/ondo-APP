import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/components/post/base_post_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

@immutable
class HomeRecommendPostList extends BasePostGrid {
  final HomeController _controller = Get.find<HomeController>();

  HomeRecommendPostList({super.key, super.title = "추천 게시물"});

  @override
  List<Widget> listBuilder() {
    return List.generate(_controller.posts.length, (index) {
      final post = _controller.posts[index];
      return PostItem(
        skills: post.skills,
        title: post.title,
        author: post.name,
        bookmarks: post.bookmarks,
        favorites: post.favoites,
        createMinutes: post.createAt.inMinutes,
        bookmarkAction: (isBookmark, total) {
          //TODO : model 정의되면 setter 적용
        },
        heartAction: (isFavorite, total) {
          //TODO : model 정의되면 setter 적용
        },
        initialBookmark: post.isBookmark,
        initialFavorite: post.isFavorite,
      );
    });
  }
}
