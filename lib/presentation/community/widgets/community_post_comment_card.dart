import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/presentation/community/widgets/community_custom_icon_button.dart';

class CommunityPostCommentCard extends StatelessWidget {
  const CommunityPostCommentCard({
    super.key,
    required this.author,
    required this.commentText,
    required this.heartTotal,
  });

  final String author;
  final String commentText;
  final int heartTotal;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Align(
            alignment: .topLeft,
            child: CustomProfileCircle(radius: AppSpacing.s24),
          ),
          AppGap.h12,
          Expanded(child: _body()),
          AppGap.h6,
          CommunityCustomIconButton(
            imagePath: AppIcon.heart.path,
            total: heartTotal,
            activeColor: AppColors.red,
            action: (isSelect, total) {
              //TODO: Comment 모델과 컨드롤러가 정의되면 추가
            },
          ),
        ],
      ),
    );
  }

  Widget _body() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        author,
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
      AppGap.v6,
      Text(
        commentText,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
