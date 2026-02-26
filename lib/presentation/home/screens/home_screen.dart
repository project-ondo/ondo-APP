import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/screens/home_search_detail_screen.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_item.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

import '../../../core/design_system/components/post/base_post_list.dart';
import '../../../core/design_system/components/post/post_item.dart';
import '../../../core/design_system/components/top_bar/main_top_search_bar.dart';



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
            _PostRankList(),
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
          _RecommendProfileList(),
          AppGap.v16,
          _RecommendPostList(),
          AppGap.v16,
        ],
      ),
    );
  }
}

@immutable
class _PostRankList extends StatelessWidget {
  final List<Map<String, dynamic>> popularPosts;

  _PostRankList() : popularPosts = [{}, {}, {}, {}, {}];

  final double _hList = 143;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          AppGap.v16,
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: _hList),
            child: _postList(),
          ),
          AppGap.v16,
          _indicator(),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      "실시간 인기 게시물",
      style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
    );
  }

  final double _hPostSpacing = AppSpacing.s6;

  Widget _postList() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, pageIndex) {
        return Column(
          spacing: _hPostSpacing,
          children: List.generate(3, (itemIndex) {
            final currentItemIndex = (pageIndex * 3) + itemIndex;

            if (currentItemIndex >= popularPosts.length) {
              return SizedBox.shrink();
            }

            return HomePostRankItem(
              title: "요즘 공부 어케 하시나요 다들",
              createAgo: 3,
              favorite: 160,
              rank: currentItemIndex + 1,
            );
          }),
        );
      },
      itemCount: (popularPosts.length ~/ 3) + 1,
    );
  }

  final double _indicatorSpacing = AppSpacing.s6;

  Widget _indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: _indicatorSpacing,
      children: [
        _circle(true),
        _circle(false),
        _circle(false),
      ],
    );
  }

  final double _indicatorSize = 4;

  Widget _circle(bool isFocus) {
    return Container(
      width: _indicatorSize,
      height: _indicatorSize,
      decoration: BoxDecoration(
        color: isFocus ? AppColors.gray80 : AppColors.gray60,
        borderRadius: AppRadius.circleRadius,
      ),
    );
  }
}

@immutable
class _RecommendProfileList extends StatelessWidget {
  final List<Map<String, dynamic>> _chats;

  _RecommendProfileList() : _chats = [{}, {}, {}, {}];

  final String _titleTest = "커피챗 추천";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        AppGap.v16,
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 160),
          child: _chatList(),
        ),
      ],
    );
  }

  Widget _title() {
    return Text(
      _titleTest,
      style: AppTextStyles.titleBold16(),
    );
  }

  Widget _chatList() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, pageIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (itemIndex) {
            final int currentIndex = (pageIndex * 3) + itemIndex;

            return currentIndex < _chats.length
                ? HomeProfileCard(
                    skill: "UI/UX",
                    name: "김유찬",
                    getStar: 4,
                  )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: (_chats.length ~/ 3) + 1,
    );
  }
}

@immutable
class _RecommendPostList extends BasePostList {
  final List<Map<String, dynamic>> posts;

  _RecommendPostList({
    super.title = "추천 게시물",
  }) : posts = [{}, {}, {}, {}, {}, {}, {}];

  @override
  List<Widget> list() {
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
