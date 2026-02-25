import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/post/base_post_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/core/design_system/components/top_bar/main_top_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/widgets/community_post_add_button.dart';

class CommunitySearchDetailScreen extends StatefulWidget {
  const CommunitySearchDetailScreen({super.key});

  @override
  State<CommunitySearchDetailScreen> createState() =>
      _CommunitySearchDetailScreenState();
}

class _CommunitySearchDetailScreenState
    extends State<CommunitySearchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      floatingActionButton: CommunityPostAddButton.dock(),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: MainTopBar(
          child: Padding(
            padding: AppPadding.screenHorizontal,
            child: Column(
              children: [
                AppGap.v16,
                _PostResults(),
                AppGap.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _PostResults extends BasePostList {
  final List<Map<String, dynamic>> posts;

  _PostResults({
    super.title = "게시물 검색 결과",
  }) : posts = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}];

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
