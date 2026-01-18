import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/widgets/base_home_post_list.dart';
import 'package:ondo/presentation/home/widgets/home_post_item.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_item.dart';
import 'package:ondo/presentation/home/widgets/home_recommend_chat.dart';
import 'package:ondo/presentation/home/widgets/home_top_bar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeTopBar(),

              AppGap.v16,

              HomePostRankList(),

              AppGap.v16,

              HomeRecommendChatList(),

              _BookMarkedPostList(posts: [{}, {}, {}]),
              _RecommendPostList(posts: [{}, {}, {}]),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class HomePostRankList extends StatelessWidget {
  final List<Map<String, dynamic>> popularPosts;

  HomePostRankList({super.key}) : popularPosts = [{}, {}, {}, {}, {}];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "실시간 인기 게시물",
          style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
        ),

        AppGap.v16,

        SizedBox(
          height: 186,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, pageIndex) {
              return Column(
                children: List.generate(3, (itemIndex) {
                  final currentItemIndex = (pageIndex * 3) + itemIndex;
                  if (currentItemIndex >= popularPosts.length) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                    child: HomePostRankItem(
                      title: "요즘 공부 어케 하시나요 다들",
                      createAgo: 3,
                      favorite: 160,
                      rank: currentItemIndex + 1,
                    ),
                  );
                }),
              );
            },
            itemCount: (popularPosts.length ~/ 3) + 1,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circle(true),
            circle(false),
            circle(false),
          ],
        ),


      ],
    );
  }

  Widget circle(bool isFocus) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: isFocus ? AppColors.gray80 : AppColors.gray60,
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}

@immutable
class HomeRecommendChatList extends StatelessWidget {
  final List<Map<String, dynamic>> _chatList;

  HomeRecommendChatList({super.key}) : _chatList = [{}, {}, {}, {}];

  final String _titleTest = "커피챗 추천";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _titleTest,
          style: AppTextStyles.titleBold16(),
        ),

        AppGap.v16,

        SizedBox(
          height: 160,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, pageIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (itemIndex) {
                  final int currentIndex = (pageIndex * 3) + itemIndex;

                  return currentIndex < _chatList.length
                      ? HomeRecommendChat(
                          skill: "UI/UX",
                          name: "김유찬",
                          getStar: 4,
                        )
                      : SizedBox.shrink();
                }),
              );
            },
            itemCount: (_chatList.length ~/ 3) + 1,
          ),
        ),
      ],
    );
  }
}

@immutable
class _BookMarkedPostList extends BaseHomePostList {
  final List<Map<String, dynamic>> posts;

  _BookMarkedPostList({required this.posts})
    : super(
        title: "즐겨찾기한 게시물",
        list: List.generate(posts.length, (index) {
          return HomePostItem(
            skills: ["UI/UX", "FrontEnd"],
            title: "요즘 UI UX",
            author: "김유찬",
            bookmarks: 12,
            favorites: 12,
            createMinutes: 4,
          );
        }),
      );
}

@immutable
class _RecommendPostList extends BaseHomePostList {
  final List<Map<String, dynamic>> posts;

  _RecommendPostList({required this.posts})
    : super(
        title: "추천 게시물",
        list: List.generate(posts.length, (index) {
          return HomePostItem(
            skills: ["UI/UX", "FrontEnd"],
            title: "요즘 UI UX",
            author: "김유찬",
            bookmarks: 12,
            favorites: 12,
            createMinutes: 4,
          );
        }),
      );
}
