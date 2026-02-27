import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/screens/home_search_detail_screen.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_item.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_list.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_chat_list.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_post_list.dart';

import '../../../core/design_system/components/post/base_post_list.dart';
import '../../../core/design_system/components/post/post_item.dart';
import '../../../core/design_system/components/top_bar/main_top_search_bar.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: MainTopSearchBar.home(
        mainPage: SingleChildScrollView(
          child: Column(
            children: [
              _highSection(),

              _lowSection(),
            ],
          ),
        ),
        resultPageBuilder: (resultModel) {
          final data = resultModel as HomeSearchModel;
          return HomeSearchDetailPage(chats: data.chats, posts: data.posts);
        },
      ),
    );
  }

  Widget _highSection() {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          children: [
            HomePostRankList(),
            AppGap.v16,
          ],
        ),
      ),
    );
  }

  Widget _lowSection() {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: Column(
        children: [
          AppGap.v16,
          HomeRecommendChatList(),
          AppGap.v16,
          HomeRecommendPostList(),
          AppGap.v16,
        ],
      ),
    );
  }
}
