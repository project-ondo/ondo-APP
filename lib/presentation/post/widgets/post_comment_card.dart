import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';

class PostCommentCard extends GetView<PostViewController> {
  const PostCommentCard({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: CustomProfileCircle(radius: AppSpacing.s24),
        ),
        AppGap.h12,
        Expanded(child: _body()),
        AppGap.h6,
        if (comment.isMy)
          GestureDetector(
            onTap: () {
              controller.deleteComment(comment);
            },
            child: Text(
              "삭제",
              style: AppTextStyles.caption(textColor: AppColors.red),
            ),
          ),
      ],
    );
  }

  Widget _body() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        comment.author,
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
      AppGap.v6,
      Text(
        comment.comment,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}