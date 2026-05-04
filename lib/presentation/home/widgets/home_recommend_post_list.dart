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
              //TODO :  정의되면 setter 적용
            },
            heartAction: (isFavorite, total) {
              //TODO : model 정의되면 setter 적용
            },
            //TODO : 서버에서 북마크, 좋아요 표시 값 전송시, 변경
            initialBookmark: false,
            initialFavorite: false,
            isMy: false,
          ),
        )
        .toList();
  }
}
