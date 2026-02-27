import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/community/controllers/post_view_controller.dart';

class CommunityPostTitle extends GetView<PostViewController> {
  const CommunityPostTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.title.value,
              style: AppTextStyles.titleBold20(textColor: AppColors.gray90),
              overflow: TextOverflow.ellipsis,
            ),
            AppGap.v16,
            Wrap(
              spacing: AppSpacing.s16,
              children: controller.postTags
                  .map(
                    (tag) => Text(
                      tag,
                      style: AppTextStyles.caption(textColor: AppColors.gray60),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
