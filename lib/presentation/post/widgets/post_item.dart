import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class PostItem extends GetView<PostController> {
  final int postId;
  final bool isMy;
  final List<String> skills;
  final String title;
  final String author;
  final int favorites;
  final int bookmarks;
  final DateTime createAt;
  final bool initialBookmark;
  final bool initialFavorite;
  final FavoriteAction? heartAction;
  final BookmarkAction? bookmarkAction;

  const PostItem({
    super.key,
    required this.postId,
    required this.isMy,
    required this.skills,
    required this.title,
    required this.author,
    required this.bookmarks,
    required this.favorites,
    required this.createAt,
    this.heartAction,
    this.bookmarkAction,
    this.initialBookmark = false,
    this.initialFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.enterPostDetail(
          context,
          isMy,
          postId,
          isFavorite: initialFavorite, // isFavorite 전달
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
    final visibleSkills = skills.take(2).toList();
    final remainCount = skills.length - 2;

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
          title,
          style: AppTextStyles.titleSm14(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        AppGap.v4,
        Text(
          author,
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
          total: favorites,
          activeColor: AppColors.red,
          action: heartAction,
          iconSize: AppSpacing.s16,
          totalStyle: AppTextStyles.caption(),
          initialIsSelected: initialFavorite,
        ),
        AppGap.h8,
        CustomIconButton(
          imagePath: AppIcon.bookmark.path,
          total: bookmarks,
          activeColor: AppColors.yellow,
          action: bookmarkAction,
          iconSize: AppSpacing.s16,
          totalStyle: AppTextStyles.caption(),
          initialIsSelected: initialBookmark,
        ),
        Spacer(),
        Text(
          AppDateUtils.timeAgo(createAt),
          style: AppTextStyles.caption(textColor: AppColors.gray50),
        ),
      ],
    );
  }
}
