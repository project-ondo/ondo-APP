import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class PostItem extends GetView<PostController> {
  final PostEntity post;
  final bool isMy;
  final FavoriteAction? heartAction;
  final BookmarkAction? bookmarkAction;

  const PostItem({
    super.key,
    required this.post,
    required this.isMy,
    this.heartAction,
    this.bookmarkAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.enterPostDetail(
          context,
          isMy,
          post.postId,
          isFavorite: post.isFavorite,
        );
      },
      child: Container(
        padding: AppPadding.card,
        decoration: BoxDecoration(
          borderRadius: AppRadius.baseRadius,
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skillList(),
            Spacer(flex: AppSpacing.s12.toInt()),
            _content(),
            Spacer(flex: AppSpacing.s16.toInt()),
            _bottomContent(),
          ],
        ),
      ),
    );
  }

  Widget _skillList() {
    final visibleSkills = post.tags.take(2).toList();
    final remainCount = post.tags.length - 2;

    return Row(
      children: [
        Expanded(
          child: Text(
            remainCount > 0
                ? "${visibleSkills.join(" ")} +$remainCount"
                : visibleSkills.join(" "),
            style: AppTextStyles.caption(textColor: AppColors.gray60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          style: AppTextStyles.titleSm14(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        AppGap.v4,
        Text(
          post.authorName,
          style: AppTextStyles.caption(textColor: AppColors.gray60),
        ),
      ],
    );
  }

  Widget _bottomContent() {
    return Row(
      children: [
        CustomIconButton(
          imagePath: AppIcon.heart.path,
          total: post.likeCount,
          activeColor: AppColors.red,
          action: heartAction,
          iconSize: AppSpacing.s16,
          totalStyle: AppTextStyles.caption(),
          initialIsSelected: post.isFavorite,
        ),
        AppGap.h8,
        CustomIconButton(
          imagePath: AppIcon.bookmark.path,
          total: post.bookmarkCount,
          activeColor: AppColors.yellow,
          action: bookmarkAction,
          iconSize: AppSpacing.s16,
          totalStyle: AppTextStyles.caption(),
          initialIsSelected: post.isBookmark,
        ),
        Spacer(),
        Text(
          AppDateUtils.timeAgo(post.createAt),
          style: AppTextStyles.caption(textColor: AppColors.gray50),
        ),
      ],
    );
  }
}
