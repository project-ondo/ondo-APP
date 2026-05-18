import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/chat/controllers/chat_review_controller.dart';

class ChatReviewDialog extends GetView<ChatReviewController> {
  const ChatReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: AppPadding.basePopup,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.popupRadius),
      child: Padding(
        padding: AppPadding.actionPopup,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("리뷰 남기기", style: AppTextStyles.titleBold20()),
              AppGap.v16,
              _starList(),
              AppGap.v16,
              _reviewCategoryList(),
              AppGap.v16,
              CustomTextField(
                controller: controller.commentController,
                hintText: "상세 내용을 입력해 주세요",
                maxLines: null,
                minLines: 4,
              ),
              AppGap.v16,
              _quitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quitButton() => Obx(
    () => CustomButton(
      text: "종료",
      variant: ButtonVariant.primary,
      onPressed: () {
        //TODO : 리뷰를 서버에 전송하는 로직
        controller.submitReview();
      },
      enabled: controller.enableSubmit.value,
    ),
  );

  Widget _reviewCategoryList() => Wrap(
    direction: Axis.horizontal,
    spacing: AppSpacing.s12,
    runSpacing: AppSpacing.s12,
    children: List.generate(
      controller.baseCategories.length,
      (index) => CustomTagCard(
        onTap: (isSelect) => controller.selectReviewTag(
          controller.baseCategories[index],
          isSelect,
        ),
        tag: controller.baseCategories[index],
        color: AppColors.gray20,
      ),
    ),
  );

  Widget _starList() => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (index) => _starIcon(index),
    ),
  );

  Widget _starIcon(int index) => GestureDetector(
    onTap: () => controller.star(index),
    child: Obx(
      () => Image.asset(
        AppIcon.star.path,
        width: AppSpacing.s28,
        height: AppSpacing.s28,
        color: controller.star.value >= index
            ? AppColors.primary
            : AppColors.gray50,
      ),
    ),
  );
}
