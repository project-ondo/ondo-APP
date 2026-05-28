import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';

class PostBody extends GetView<PostViewController> {
  const PostBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        AppGap.h12,
        Text(AppDateUtils.timeAgo(DateTime.now())),
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
      _heartButton(),
      _bookmarkButton(),
    ],
  );

  Widget _heartButton() => GestureDetector(
    onTap: () => controller.toggleLike(!controller.selectHeart.value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppIcon.heart.path,
          color: controller.selectHeart.value
              ? AppColors.red
              : AppColors.gray50,
          height: AppSpacing.s32,
          width: AppSpacing.s32,
        ),
        AppGap.h4,
        Text(
          '${controller.heartTotal.value}',
          style: AppTextStyles.textMedium(),
        ),
      ],
    ),
  );

  Widget _bookmarkButton() => GestureDetector(
    onTap: () {
      controller.selectBookMark.value = !controller.selectBookMark.value;
      controller.selectBookMark.value
          ? controller.bookMarkTotal.value += 1
          : controller.bookMarkTotal.value -= 1;
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppIcon.bookmark.path,
          color: controller.selectBookMark.value
              ? AppColors.yellow
              : AppColors.gray50,
          height: AppSpacing.s32,
          width: AppSpacing.s32,
        ),
        AppGap.h4,
        Text(
          '${controller.bookMarkTotal.value}',
          style: AppTextStyles.textMedium(),
        ),
      ],
    ),
  );
}
