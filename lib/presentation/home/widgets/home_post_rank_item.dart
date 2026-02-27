import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';

@immutable
class HomePostRankItem extends StatelessWidget {
  final int rank;
  final String title;
  final int createAgo;
  final int favorite;
  final FavoriteAction? heartAction;

  const HomePostRankItem({
    super.key,
    required this.title,
    required this.createAgo,
    required this.favorite,
    required this.rank,
    this.heartAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _rank(),
        Expanded(child: _content()),
        AppGap.h16,
        CustomIconButton(
          imagePath: AppIcon.heart.path,
          total: favorite,
          activeColor: AppColors.red,
          action: heartAction,
          iconSize: AppSpacing.s16,
          totalStyle: AppTextStyles.caption(),
        ),
      ],
    );
  }

  Widget _rank() {
    return SizedBox.square(
      dimension: AppSpacing.s42,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "$rank",
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
          title,
          style: AppTextStyles.textMedium(textColor: AppColors.gray90),
        ),
        AppGap.v4,
        Text(
          "$createAgo일 전",
          style: AppTextStyles.subCaption(textColor: AppColors.gray60),
        ),
      ],
    );
  }
}
