import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/components/post/base_post_list.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';
import '../../../core/design_system/components/post/post_item.dart';

class HomeSearchDetailPage extends StatelessWidget {
  const HomeSearchDetailPage({
    super.key,
    required this.chats,
    required this.posts,
  });

  final List<Map<String, dynamic>> chats;
  final List<Map<String, dynamic>> posts;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            children: [
              AppGap.v16,
              _ProfileResults(
                chats: [],
              ),
              AppGap.v16,
              _PostResults(
                posts: [],
              ),
              AppGap.v16,
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _ProfileResults extends StatelessWidget {
  final List<Map<String, dynamic>> chats;

  const _ProfileResults({required this.chats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "프로필 검색 결과",
          style: AppTextStyles.titleBold16(),
        ),
        AppGap.v16,
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 160),
          child: _chatList(),
        ),
      ],
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

            return currentIndex < chats.length
                ? HomeProfileCard(
                    skill: "UI/UX",
                    name: "김유찬",
                    getStar: 4,
                  )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: (chats.length ~/ 3) + 1,
    );
  }
}

@immutable
class _PostResults extends BasePostList {
  final List<Map<String, dynamic>> posts;

  const _PostResults({
    super.title = "게시물 검색 결과",
    required this.posts,
  });

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
