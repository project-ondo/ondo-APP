import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

import 'post_item.dart';

@immutable
class PostGridList extends StatelessWidget {
  final String title;
  final List<PostItem> list;
  final bool scrollable;

  const PostGridList({
    super.key,
    required this.title,
    this.scrollable = false,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
          ),
          AppGap.v16,
          GridView(
            shrinkWrap: true,
            physics: scrollable ? null : NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.s16,
              crossAxisSpacing: AppSpacing.s16,
              childAspectRatio: 3 / 2,
            ),
            children: list,
          ),
        ],
      ),
    );
  }
}
