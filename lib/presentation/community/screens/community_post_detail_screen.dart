import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/core/design_system/components/post/indicator_post_page_list.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/core/design_system/components/post/post_list_indicator.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/post_view_controller.dart';
import 'package:ondo/presentation/community/widgets/community_custom_icon_button.dart';
import 'package:ondo/presentation/community/widgets/community_post_comment_card.dart';
import 'package:ondo/presentation/community/widgets/community_post_report_dialog.dart';


class CommunityPostDetailScreen extends StatefulWidget {
  const CommunityPostDetailScreen.myPost({super.key}) : isMy = true;

  const CommunityPostDetailScreen.otherPost({super.key}) : isMy = false;

  final bool isMy;

  @override
  State<CommunityPostDetailScreen> createState() =>
      _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  late final PostViewController _controller;

  @override
  void initState() {
    _controller = Get.put(PostViewController());
    super.initState();
  }

  void _showPostReportDialog() {
    showDialog(
      context: context,
      builder: (context) => CommunityPostReportDialog(),
    );
  }

  void _showDeletePostAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: "알림",
        comment: "정말 게시물 삭제하시겠어요?",
        actionLeft: () => Navigator.pop(context),
        actionRight: () {
          _controller.deletePostRequest();
          Navigator.pop(context);
        },
        rightActionText: "삭제",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._top(),
            AppGap.v16,
            _body(),
            _footer(),
          ],
        ),
      ),
    );
  }

  List<Widget> _top() => [
    CustomBackButton(
      moreOptions: true,
      itemBuilder: (context) => [
        if (!widget.isMy)
          _topPopupItem("게시물 신고하기", _showPostReportDialog)
        else ...[
          _topPopupItem("게시물 수정하기", () {}),
          _topPopupItem("게시물 삭제하기", _showDeletePostAlertDialog),
        ],
      ],
    ),
    _Title(),
  ];

  Widget _body() => Padding(
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        _Body(),
        AppGap.v24,
        _CommentList(),
      ],
    ),
  );

  Widget _footer() => Container(
    color: AppColors.background,
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        AppGap.v16,
        _RelatedPostList(),
      ],
    ),
  );

  PopupMenuEntry<String> _topPopupItem(String title, VoidCallback onTap) =>
      PopupMenuItem(
        padding: AppPadding.popupManuButton,
        onTap: onTap,
        child: Center(child: Text(title)),
      );
}

class _Title extends GetView<PostViewController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.title.value,
              style: AppTextStyles.titleBold20(textColor: AppColors.gray90),
              overflow: TextOverflow.ellipsis,
            ),
            AppGap.v16,
            Wrap(
              spacing: AppSpacing.s16,
              children: controller.postTags
                  .map(
                    (tag) => Text(
                      tag,
                      style: AppTextStyles.caption(textColor: AppColors.gray60),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends GetView<PostViewController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _top(),
        AppGap.v16,
        _content(),
        AppGap.v16,
        _buttonList(),
      ],
    );
  }

  Widget _top() => DefaultTextStyle(
    style: AppTextStyles.caption(textColor: AppColors.gray60),
    child: Row(
      children: [
        CustomProfileCircle(radius: AppSpacing.s24),
        AppGap.h12,
        Expanded(child: Text(controller.authorName.value)),
        Text("${controller.postAt.value.inMinutes}분전"),
      ],
    ),
  );

  Widget _content() => Text(
    controller.bodyText.value,
    style: AppTextStyles.textMedium(textColor: AppColors.gray90),
    textAlign: .start,
  );

  Widget _buttonList() => Row(
    spacing: AppSpacing.s16,
    children: [
      CommunityCustomIconButton(
        imagePath: AppIcon.heart.path,
        action: (isSelect, total) {
          controller.selectHeart = isSelect;
          controller.heartTotal = total;
        },
        activeColor: AppColors.red,
        total: controller.heartTotal,
        initialIsSelected: controller.selectHeart,
      ),
      CommunityCustomIconButton(
        imagePath: AppIcon.bookmark.path,
        action: (isSelect, total) {
          controller.selectBookMark = isSelect;
          controller.bookMarkTotal = total;
        },
        activeColor: AppColors.yellow,
        total: controller.bookMarkTotal,
        initialIsSelected: controller.selectBookMark,
      ),
    ],
  );
}

class _CommentList extends StatefulWidget {
  @override
  State<_CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<_CommentList> {
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 360,
      ),
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

class _RelatedPostList extends StatelessWidget {
  _RelatedPostList();

  final List<PostItem> posts = List.generate(
    32,
    (index) => PostItem(
      skills: ["UI/UX", "FrontEnd"],
      title: "요즘 UI UX",
      author: "김유찬",
      bookmarks: 12,
      favorites: 12,
      createMinutes: 4,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return IndicatorPostPageList(title: "관련 게시물", items: posts);
  }
}
