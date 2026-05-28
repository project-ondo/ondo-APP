import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/screens/home_search_screen.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_list.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_profile_list.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';
import '../../search/widgets/main_top_search_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: MainTopSearchBar(
        pageId: "home",
        mainPage: SingleChildScrollView(child: _body()),
        resultPageBuilder: (state) {
          if (state.query.trim().isEmpty && state.tags.isEmpty) return null;
          controller.search(query: state.query, tags: state.tags.toList());
          return HomeSearchScreen();
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        HomePostRankList(),
        AppGap.v16,
        HomeProfileList(title: "커피챗 추천", controller: controller),
        AppGap.v16,
        PostGridList(
          title: "추천 게시물",
          list: controller.viewPostList
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
                    controller.toggleLike(post.postId, isFavorite);
                  },
                  initialBookmark: false,
                  initialFavorite: post.isFavorite,
                  isMy: true,
                ),
              )
              .toList(),
        ),
        AppGap.v16,
      ],
    );
  }
}
