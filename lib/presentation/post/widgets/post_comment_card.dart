import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/data/models/comment/response/comment_model.dart';

class PostCommentCard extends GetView<PostViewController> {
  const PostCommentCard({
    super.key,
    required this.comment,
  });

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        GestureDetector(
          onTap: () {
            // comment_id가 필요할 수 있으니 확인해 보세요!
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
    );
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