import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/domain/entities/comment/comment_entity.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';

class PostCommentCard extends GetView<PostViewController> {
  const PostCommentCard({
    super.key,
    required this.comment,
  });

  final CommentEntity comment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (details) =>
          _showReportMenu(context, details.globalPosition),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomProfileCircle(
            radius: AppSpacing.s24,
          ),
          AppGap.h12,
          Expanded(
            child: _body(),
          ),
          AppGap.h6,
          if (comment.isMy)
            GestureDetector(
              onTap: () {
                controller.deleteComment(comment);
              },
              child: Text(
                '삭제',
                style: AppTextStyles.caption(
                  textColor: AppColors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showReportMenu(BuildContext context, Offset position) {
    if (comment.isMy) return;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      color: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.baseRadius),
      constraints: const BoxConstraints(minWidth: 0),
      items: [
        PopupMenuItem(
          value: 'report',
          padding: AppPadding.popupManuButton,
          child: const Center(child: Text('신고하기')),
        ),
      ],
    ).then((value) {
      if (value == 'report' && context.mounted) {
        controller.reportComment(context, comment);
      }
    });
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.author ?? '',
          style: AppTextStyles.caption(
            textColor: AppColors.gray60,
          ),
        ),
        AppGap.v6,
        Text(
          comment.content,
          style: AppTextStyles.caption(
            textColor: AppColors.gray90,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
