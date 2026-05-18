import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/presentation/search/widgets/main_top_search_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/community/widgets/community_filter_tag_list.dart';
import 'package:ondo/presentation/community/widgets/community_post_add_button.dart';
import 'package:ondo/presentation/community/widgets/community_post_list.dart';

//TODO : Binding CommunityController 필수
class CommunityMainScreen extends GetView<CommunityController> {
  const CommunityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      floatingActionButton: CommunityPostAddButton.float(),
      backgroundColor: AppColors.background,
      body: MainTopSearchBar(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screenHorizontal,
            child: Column(
              children: [
                AppGap.v16,
                CommunityFilterTagList(),
                AppGap.v16,
                CommunityPostList(),
                AppGap.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
