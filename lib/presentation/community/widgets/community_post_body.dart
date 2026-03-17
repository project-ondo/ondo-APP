import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';

class CommunityPostBody extends GetView<PostViewController> {
  const CommunityPostBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _top(),
        AppGap.v16,
        _content(),
        AppGap.v16,
        _buttonList(),
      ],
    );
  }

  Widget _top() => DefaultTextStyle(
    style: AppTextStyles.caption(textColor: AppColors.gray60),
    child: Row(
      children: [
        CustomProfileCircle(radius: AppSpacing.s24),
        AppGap.h12,
        Expanded(child: Text(controller.authorName.value)),
        Text("${controller.postAt.value.inMinutes}분전"),
      ],
    ),
  );

  Widget _content() => Text(
    controller.bodyText.value,
    style: AppTextStyles.textMedium(textColor: AppColors.gray90),
    textAlign: .start,
  );

  Widget _buttonList() => Row(
    spacing: AppSpacing.s16,
    children: [
      CustomIconButton(
        iconSize: AppSpacing.s32,
        totalStyle: AppTextStyles.textMedium(),
        imagePath: AppIcon.heart.path,
        action: (isSelect, total) {
          controller.selectHeart = isSelect;
          controller.heartTotal = total;
        },
        activeColor: AppColors.red,
        total: controller.heartTotal,
        initialIsSelected: controller.selectHeart,
      ),
      CustomIconButton(
        iconSize: AppSpacing.s32,
        totalStyle: AppTextStyles.textMedium(),
        imagePath: AppIcon.bookmark.path,
        action: (isSelect, total) {
          controller.selectBookMark = isSelect;
          controller.bookMarkTotal = total;
        },
        activeColor: AppColors.yellow,
        total: controller.bookMarkTotal,
        initialIsSelected: controller.selectBookMark,
      ),
    ],
  );
}