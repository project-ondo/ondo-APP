import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_icon.dart';
import '../../app_layout.dart';
import '../../app_text_styles.dart';

class PostItem extends StatelessWidget {
  final List<String> skills;
  final String title;
  final String author;
  final int favorites;
  final int bookmarks;
  final int createMinutes;

  const PostItem({
    super.key,
    required this.skills,
    required this.title,
    required this.author,
    required this.bookmarks,
    required this.favorites,
    required this.createMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        _customIcon(AppIcon.heart.path, favorites),
        AppGap.h8,
        _customIcon(AppIcon.bookmark.path, bookmarks),

        Spacer(),

        Text(
          "$createMinutes분전",
          style: AppTextStyles.caption(textColor: AppColors.gray50),
        ),
      ],
    );
  }

  Widget _customIcon(String iconPath, int total) {
    final double iconSize = 16;
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: iconSize,
          width: iconSize,
        ),
        Text(
          "$total",
          style: AppTextStyles.caption(textColor: AppColors.gray60),
        ),
      ],
    );
  }
}
