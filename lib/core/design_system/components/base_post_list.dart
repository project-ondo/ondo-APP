import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

import '../app_icon.dart';

@immutable
abstract class BasePostList extends StatelessWidget {
  final String title;
  final int floor;
  final double itemHeight;


  const BasePostList({super.key, required this.title, this.floor = 2, this.itemHeight = 143});

  List<Widget> list();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),

        AppGap.v16,

        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (floor * itemHeight) - 16,
            maxWidth: double.maxFinite,
          ),
          child: _postList(),
        ),
      ],
    );
  }

  Widget _title() {
    return Text(
      title,
      style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
    );
  }

  final double _itemSpace = AppSpacing.s16;

  Widget _postList() {
    final int pageTotal = list().length ~/ (floor * 2);

    return PageView.builder(
      itemBuilder: (context, pageIndex) {
        int startItemIndex = pageIndex * (floor * 2);

        int endItemIndex = startItemIndex + (floor * 2);

        return GridView(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: _itemSpace,
            crossAxisSpacing: _itemSpace,
            childAspectRatio: 0.7,
          ),
          children: List.of(
            list().sublist(
              startItemIndex,
              startItemIndex +
                  (endItemIndex > list().length
                      ? list().length % (pageTotal * (floor * 2))
                      : (floor * 2)),
            ),
          ),
        );
      },
      itemCount: pageTotal + 1,
    );
  }
}

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
