import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class HomeRecommendPostList extends BasePostGrid {
  final HomeController _controller = Get.find<HomeController>();

  HomeRecommendPostList({super.key, super.title = "추천 게시물"});

  @override
  Widget build(BuildContext context) => Obx(() => super.build(context));

  @override
  List<Widget> listBuilder() {
    return _controller.viewPostList
        .map(
          (post) => PostItem(
            postId: post.postId,
            skills: post.tags,
            title: post.title,
            author: post.authorName,
            bookmarks: post.bookmarkCount,
            favorites: post.likeCount,
            createAt: post.createAt,
            bookmarkAction: (isBookmark, total) {
              //TODO : 북마크 api 개발 이후 구현
            },
            heartAction: (isFavorite, total) {
              _controller.toggleLike(post.postId, isFavorite);
            },
            initialBookmark: false,
            initialFavorite: post.isFavorite,
            isMy: true,
          ),
        )
        .toList();
  }
}
