import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';
import 'package:ondo/presentation/community/screens/community_post_create_screen.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/widgets/post_body.dart';
import 'package:ondo/presentation/post/widgets/post_comment_list.dart';
import 'package:ondo/presentation/post/widgets/post_title.dart';
import 'package:ondo/presentation/post/widgets/related_post_list.dart';
import 'package:ondo/presentation/post/widgets/post_report_dialog.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostViewController>();
  }

  void _showPostReportDialog() {
    showDialog(
      context: context,
      builder: (context) => PostReportDialog(),
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
          Navigator.pop(context);
          _controller.deletePost();
        },
        rightActionText: "삭제",
      ),
    );
  }

  void _goToEditScreen() {
    Get.delete<CommunityPostCreateController>(force: true);
    Get.lazyPut(
      () => CommunityPostCreateController(
        createUseCase: Get.find<CreatePostUseCase>(),
        updateUseCase: Get.find<UpdatePostUseCase>(),
        isEditMode: true,
        editPostId: _controller.postId,
        initialTitle: _controller.title.value,
        initialContent: _controller.bodyText.value,
        initialTags: _controller.postTags.toList(),
      ),
    );
    Get.to(() => CommunityPostCreateScreen());
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
            RelatedPostList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _top() => [
    CustomBackButton(
      moreOptions: true,
      itemBuilder: (context) => [
        _topPopupItem("게시물 수정하기", _goToEditScreen),
        _topPopupItem("게시물 삭제하기", _showDeletePostAlertDialog),
        _topPopupItem("게시물 신고하기", _showPostReportDialog),
      ],
    ),
    PostTitle(),
  ];

  Widget _body() => Padding(
    padding: AppPadding.screenHorizontal,
    child: Column(
      children: [
        PostBody(),
        AppGap.v24,
        PostCommentList(),
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
