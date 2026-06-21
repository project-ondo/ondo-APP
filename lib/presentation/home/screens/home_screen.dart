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
import 'package:ondo/presentation/search/states/search_page_state.dart';
import '../../search/widgets/main_top_search_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: MainTopSearchBar(
        pageState: SearchPageState.home,
        mainPage: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
              controller.loadMorePosts();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: _body(),
          ),
        ),
        resultPageBuilder: (state) {
          if (state.keyword.isEmpty) return null;
          final keyword = state.keyword;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.search(keyword);
          });
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

        HomeProfileList(
          title: "커피챗 추천",
          controller: controller,
          onEndReached: controller.loadMoreUsers,
        ),

        AppGap.v16,

        Obx(
              () => PostGridList(
            title: "추천 게시물",
            list: controller.viewPostList
                .map(
                  (post) => PostItem(
                post: post,
                isMy: true,
                heartAction: (isFavorite, total) {
                  controller.toggleLike(post.postId, isFavorite);
                },
                bookmarkAction: (isBookmark, total) {},
              ),
            )
                .toList(),
          ),
        ),

        AppGap.v16,
      ],
    );
  }
}