import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/community/widgets/community_post_body.dart';
import 'package:ondo/presentation/community/widgets/community_post_title.dart';
import 'package:ondo/presentation/community/widgets/community_comment_list.dart';
import 'package:ondo/presentation/community/widgets/community_related_post_list.dart';
import 'package:ondo/presentation/community/widgets/community_post_report_dialog.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen.myPost({super.key}) : isMy = true;

  const PostDetailScreen.otherPost({super.key}) : isMy = false;

  final bool isMy;

  @override
  State<PostDetailScreen> createState() =>
      _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostViewController _controller;

  @override
  void initState() {
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
    CommunityPostTitle(),
  ];

  Widget _body() => Padding(
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        CommunityPostBody(),
        AppGap.v24,
        CommunityCommentList(),
      ],
    ),
  );

  Widget _footer() => Container(
    color: AppColors.background,
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        AppGap.v16,
        CommunityRelatedPostList(),
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
