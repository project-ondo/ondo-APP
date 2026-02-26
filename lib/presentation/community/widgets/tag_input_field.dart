import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/community/widgets/tag_chip.dart';
import 'package:ondo/presentation/community/controllers/tag_input_field_controller.dart';

class TagInputField extends StatelessWidget {
  const TagInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TagInputController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '태그 등록',
          style: AppTextStyles.textMedium(textColor: AppColors.gray80),
        ),
        AppGap.v4,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.gray20,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => controller.tags.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.tags
                        .map((tag) => TagChip(
                      tag: tag,
                      onRemove: () => controller.removeTag(tag),
                    ))
                        .toList(),
                  ),
                  AppGap.v16,
                ],
              )
                  : const SizedBox.shrink()),
              TextField(
                  controller: controller.textController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: controller.addTag,
                  decoration: InputDecoration(
                    hintText: '태그를 입력해주세요',
                    hintStyle: AppTextStyles.textMedium(
                      textColor: AppColors.gray60,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}