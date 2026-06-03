import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/domain/entities/post/post_rank_entity.dart';

@immutable
class HomePostRankItem extends StatelessWidget {
  final PostRankEntity post;
  final FavoriteAction? heartAction;
  final VoidCallback? onTap;

  const HomePostRankItem({
    super.key,
    required this.post,
    this.heartAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _rank(),
          Expanded(child: _content()),
          AppGap.h16,
          CustomIconButton(
            imagePath: AppIcon.heart.path,
            total: post.likeCount,
            activeColor: AppColors.red,
            action: heartAction,
            iconSize: AppSpacing.s16,
            totalStyle: AppTextStyles.caption(),
          ),
        ],
      ),
    );
  }

  Widget _rank() {
    return SizedBox.square(
      dimension: AppSpacing.s42,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "${post.rank}",
          style: AppTextStyles.textMedium(textColor: AppColors.primary),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          style: AppTextStyles.textMedium(textColor: AppColors.gray90),
        ),
        AppGap.v4,
        Text(
          AppDateUtils.timeAgo(post.createAt),
          style: AppTextStyles.subCaption(textColor: AppColors.gray60),
        ),
      ],
    );
  }
}
