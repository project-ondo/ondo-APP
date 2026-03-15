import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/screens/home_search_page.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_list.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_chat_list.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_post_list.dart';

import '../../search/widgets/main_top_search_bar.dart';

//TODO : Binding HomeController 필수
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: MainTopSearchBar(
        pageId: "home",
        mainPage: SingleChildScrollView(
          child: Column(
            children: [
              _highSection(),

              _lowSection(),
            ],
          ),
        ),
        resultPageBuilder: (state) {
          if (state.query.trim().isEmpty) return null;
          controller.searchResultController.searchResultInfo(state.query.value);
          return HomeSearchPage();
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
