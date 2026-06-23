import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/widgets/post_body.dart';
import 'package:ondo/presentation/post/widgets/post_comment_list.dart';
import 'package:ondo/presentation/post/widgets/post_title.dart';
import 'package:ondo/presentation/post/widgets/related_post_list.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostViewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PostViewController>();
  }

  void _onBack() {
    final map = {
      'postId': controller.postId,
      'isLiked': controller.selectHeart.value,
      'likeCount': controller.heartTotal.value,
      'changed': controller.selectHeart.value != controller.initialHeartState,
      'deleted': false,
    };
    debugPrint(' _onBack: $map');
    context.pop(map);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onBack();
      },
      child: BaseScaffold(
        body: Obx(() {
          if (controller.isLoading.value && controller.post.value == null) {
            return const AppLoadingIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ..._top(),
                AppGap.v16,
                _body(),
                RelatedPostList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _top() => [
    //TODO : controller에서 publicId를 받아오면, 분기 처리
    CustomBackButton(
      backAction: _onBack,
      moreOptions: true,
      itemBuilder: (context) => [
        _topPopupItem("게시물 수정하기", controller.editPost),
        _topPopupItem("게시물 삭제하기", controller.deletePost),
        _topPopupItem("게시물 신고하기", () => controller.reportPost(context)),
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