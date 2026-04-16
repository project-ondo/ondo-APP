import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';
import 'package:ondo/presentation/home/widgets/base_home_profile_list.dart';
import 'package:ondo/presentation/post/widgets/base_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

import '../../../core/design_system/app_layout.dart';

class HomeSearchScreen extends StatelessWidget {
  const HomeSearchScreen({super.key});

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
              _ProfileResults(),
              AppGap.v16,
              _PostResults(),
              AppGap.v16,
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _ProfileResults extends BaseHomeProfileList {
  _ProfileResults() : super(title: "커피챗 추천");
  final HomeSearchResultController _controller =
      Get.find<HomeSearchResultController>();

  @override
  List<Widget> listBuilder() => List.generate(
    _controller.viewUserList.length,
    (index) {
      final chat = _controller.viewUserList[index];
      return HomeProfileCard(
        skill: chat.interests.first,
        name: chat.displayName,
        rating: chat.ratingCount,
      );
    },
  );
}

@immutable
class _PostResults extends BasePostGrid {
  final HomeSearchResultController _controller =
      Get.find<HomeSearchResultController>();

  _PostResults({super.title = "게시물 검색 결과"});

  @override
  List<Widget> listBuilder() {
    return List.generate(_controller.viewPostList.length, (index) {
      return Obx(() {
        final post = _controller.viewPostList[index];
        return PostItem(
          skills: post.tags,
          title: post.title,
          author: post.authorName,
          //TODO : 북마크 api 요구됨
          bookmarks: post.likeCount,
          favorites: post.likeCount,
          createAt: post.createAt,
        );
      });
    });
  }
}
