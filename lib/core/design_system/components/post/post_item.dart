import 'package:flutter/cupertino.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //분야 표시 영역
          _skillList(),
          AppGap.v12,

          //제목 + 작성자 표시 영역
          _content(),
          AppGap.v16,

          //하단 북마크, 좋아요 + 생성 시간 표시 영역
          _sunContent(),
        ],
      ),
    );
  }

  final double _skillSpacing = AppSpacing.s16;

  Widget _skillList() {
    return Row(
      spacing: _skillSpacing,
      children: List.generate(skills.length, (index) {
        return Row(
          children: [
            Text(
              skills[index],
              style: AppTextStyles.caption(textColor: AppColors.gray60),
            ),
          ],
        );
      }),
    );
  }

  Widget _content() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _sunContent() {
    return Row(
      children: [
        _customIcon(AppIcon.heart.path, favorites),

        AppGap.h8,

        _customIcon(AppIcon.bookmark.path, bookmarks),

        AppGap.h8,

        Expanded(
          child: Text(
            "$createMinutes분전",
            style: AppTextStyles.caption(textColor: AppColors.gray50),
          ),
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