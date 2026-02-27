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
            _PostRankList(),
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
          _RecommendChatList(),
          AppGap.v16,
          _RecommendPostList(),
          AppGap.v16,
        ],
      ),
    );
  }
}

@immutable
class _PostRankList extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  _PostRankList()
    : posts = [
        for (int i = 0; i < 5; i++) ...{{}, {}, {}, {}},
      ];

  @override
  State<_PostRankList> createState() => _PostRankListState();
}

class _PostRankListState extends State<_PostRankList> {
  late final PageController _pageController;

  ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  void initState() {
    _pageController = PageController(initialPage: curIndex.value);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getPageTotal() => (widget.posts.length / 3).ceil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "실시간 인기 게시물",
            style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
          ),
          AppGap.v16,
          Expanded(child: _postList()),
          AppGap.v16,
          _indicator(),
        ],
      ),
    );
  }

  Widget _postList() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (value) {
        curIndex.value = value;
      },
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, pageIndex) {
        return Column(
          spacing: AppSpacing.s16,
          children: List.generate(3, (itemIndex) {
            final currentItemIndex = (pageIndex * 3) + itemIndex;

            return currentItemIndex < widget.posts.length
                ? HomePostRankItem(
                    title: "요즘 공부 어케 하시나요 다들",
                    createAgo: 3,
                    favorite: 160,
                    rank: currentItemIndex + 1,
                  )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: _getPageTotal(),
    );
  }

  Widget _indicator() {
    return ValueListenableBuilder(
      valueListenable: curIndex,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.s6,
          children: List.generate(
            3,
            (index) => _indicatorIcon(index == value % 3),
          ),
        );
      },
    );
  }

  Widget _indicatorIcon(bool isFocus) {
    return Container(
      width: AppSpacing.s4,
      height: AppSpacing.s4,
      decoration: BoxDecoration(
        color: isFocus ? AppColors.gray80 : AppColors.gray60,
        borderRadius: AppRadius.circleRadius,
      ),
    );
  }
}

@immutable
class _RecommendChatList extends StatelessWidget {
  final List<Map<String, dynamic>> _chats;

  _RecommendChatList()
    : _chats = [
        for (int i = 0; i < 5; i++) ...{{}, {}, {}, {}},
      ];

  int _getPageTotal() => (_chats.length / 3).ceil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "커피챗 추천",
            style: AppTextStyles.titleBold16(),
          ),
          AppGap.v16,
          Expanded(child: _chatList()),
        ],
      ),
    );
  }

  Widget _chatList() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, pageIndex) {
        return Row(
          spacing: AppSpacing.s16,
          children: List.generate(3, (itemIndex) {
            final int currentItemIndex = (pageIndex * 3) + itemIndex;

            return currentItemIndex < _chats.length
                ? Flexible(
                    child: HomeProfileCard(
                      skill: "UI/UX",
                      name: "김유찬",
                      rating: 4,
                    ),
                  )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: _getPageTotal(),
    );
  }
}

@immutable
class _RecommendPostList extends BasePostGrid {
  final List<Map<String, dynamic>> posts;

  _RecommendPostList({super.title = "추천 게시물", super.gridHeight = 320})
    : posts = [
        for (int i = 0; i < 5; i++) ...{{}, {}, {}, {}},
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
