import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/community/widgets/community_post_comment_card.dart';

import '../../post/widgets/post_list_indicator.dart';

class CommunityCommentList extends StatefulWidget {
  const CommunityCommentList({super.key});

  @override
  State<CommunityCommentList> createState() => _CommunityCommentListState();
}

class _CommunityCommentListState extends State<CommunityCommentList> {
  late final PageController _pageController;
  final PostViewController _controller = Get.find<PostViewController>();

  final ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getStartIndex(int index) => index * 4;

  int _getLastIndex(int index) =>
      min(_getStartIndex(index) + 4, _controller.comments.length);

  int _getTotalPage() => (_controller.comments.length / 4).ceil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(),
          AppGap.v16,
          Expanded(
            child: Obx(
              () => PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  curIndex.value = value;
                },
                itemCount: _getTotalPage(),
                itemBuilder: (context, index) => Center(
                  child: _commentView(
                    _getStartIndex(index),
                    _getLastIndex(index),
                  ),
                ),
              ),
            ),
          ),
          AppGap.v16,
          ValueListenableBuilder(
            valueListenable: curIndex,
            builder: (context, value, _) => PostListIndicator(
              currentPage: value,
              totalPage: _getTotalPage(),
              onTap: (value) {
                _pageController.animateToPage(
                  value,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() => Row(
    children: [
      Text("댓글", style: AppTextStyles.titleSm16(textColor: AppColors.gray90)),
      AppGap.h12,
      Text(
        "${_controller.comments.length}",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
    ],
  );

  Widget _commentView(int startIndex, int lastIndex) {
    final subComments = _controller.comments.sublist(startIndex, lastIndex);
    return Column(
      spacing: AppSpacing.s16,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...subComments.map(
          (comment) => CommunityPostCommentCard(
            author: comment.author,
            commentText: comment.comment,
            heartTotal: comment.heartTotal,
          ),
        ),
      ],
    );
  }
}
