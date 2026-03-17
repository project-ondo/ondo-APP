import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

@immutable
class HomeRecommendPostList extends BasePostGrid {
  final HomeController _controller = Get.find<HomeController>();

  HomeRecommendPostList({super.key, super.title = "추천 게시물"});

  @override
  List<Widget> listBuilder() {
    return _controller.viewPostList
        .map(
          (post) => PostItem(
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
          ),
        )
        .toList();
  }
}
