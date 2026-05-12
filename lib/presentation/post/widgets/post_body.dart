import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_icon_button.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';

class PostBody extends GetView<PostViewController> {
  const PostBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          _top(),
          AppGap.v16,
          _content(),
          AppGap.v16,
          _buttonList(),
        ],
      ),
    );
  }

  Widget _top() => DefaultTextStyle(
    style: AppTextStyles.caption(textColor: AppColors.gray60),
    child: Row(
      children: [
        CustomProfileCircle(radius: AppSpacing.s24),
        AppGap.h12,
        Expanded(child: Text(controller.authorName.value)),
        Text(AppDateUtils.timeAgo(DateTime.now())), // TODO: API에서 날짜 받으면 수정
      ],
    ),
  );

  Widget _content() => Text(
    controller.bodyText.value,
    style: AppTextStyles.textMedium(textColor: AppColors.gray90),
    textAlign: TextAlign.start,
  );

  Widget _buttonList() => Row(
    spacing: AppSpacing.s16,
    children: [
      CustomIconButton(
        iconSize: AppSpacing.s32,
        totalStyle: AppTextStyles.textMedium(),
        imagePath: AppIcon.heart.path,
        action: (isSelect, total) {
          controller.toggleLike(isSelect);
        },
        activeColor: AppColors.red,
        total: controller.heartTotal.value,
        initialIsSelected: controller.selectHeart.value,
      ),
      CustomIconButton(
        iconSize: AppSpacing.s32,
        totalStyle: AppTextStyles.textMedium(),
        imagePath: AppIcon.bookmark.path,
        action: (isSelect, total) {
          controller.selectBookMark.value = isSelect;
          controller.bookMarkTotal.value = total;
        },
        activeColor: AppColors.yellow,
        total: controller.bookMarkTotal.value,
        initialIsSelected: controller.selectBookMark.value,
      ),
    ],
  );
}