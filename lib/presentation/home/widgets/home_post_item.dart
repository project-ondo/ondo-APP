import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class HomePostItem extends StatelessWidget {
  final List<String> skills;
  final String title;
  final String author;
  final int favorites;
  final int bookmarks;
  final int createMinutes;

  const HomePostItem({
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
      width: 182,
      padding: AppPadding.card,
      decoration: BoxDecoration(
        borderRadius: AppRadius.baseRadius,
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //분야 표시 영역
          Row(
            spacing: AppSpacing.s12,
            children: List.generate(skills.length, (index) {
              return Text(
                skills[index],
                style: AppTextStyles.caption(textColor: AppColors.gray60),
              );
            }),
          ),

          AppGap.v12,

          //제목 영역
          Text(
            title,
            style: AppTextStyles.titleSm14(),
          ),

          //작성자 작성자 표시 영역
          Text(
            author,
            style: AppTextStyles.caption(),
          ),

          AppGap.v16,

          //하단 북마크, 좋아요 + 생성 시간 표시 영역
          Row(
            spacing: AppSpacing.s8,
            children: [
              customIcon(AppIcon.heart.path, favorites),
              customIcon(AppIcon.bookmark.path, bookmarks),
              Expanded(
                child: Text(
                  "${createMinutes}분전",
                  style: AppTextStyles.caption(textColor: AppColors.gray50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget customIcon(String iconPath, int total) {
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
