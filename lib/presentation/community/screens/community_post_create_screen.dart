import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/community/controllers/tag_input_field_controller.dart';
import 'package:ondo/presentation/community/widgets/tag_input_field.dart';
import 'package:ondo/presentation/community/controllers/community_post_create_screen_controller.dart';


class CommunityPostCreateScreen extends GetView<CommunityPostCreateController> {
  static const _contentMinLength = 10;
  static const _contentMaxLength = 3000;

  const CommunityPostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TagInputController());

    return BaseScaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomBackButton(moreOptions: false),
                  Padding(
                    padding: AppPadding.topBar,
                    child: LabelTextField(
                      label: '글 제목',
                      controller:controller.titleController,
                      hintText: '제목을 입력해주세요',
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: AppPadding.topBar,
                    child: const TagInputField(),
                  ),
                  Padding(
                    padding: AppPadding.topBar,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LabelTextField(
                          label: '게시물 내용',
                          controller: controller.contentController,
                          hintText: '게시물 내용을 입력해주세요',
                          minLines:  _contentMinLength,
                          maxLines: null,
                          maxLength: _contentMaxLength,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced
                        ),
                        AppGap.v4,
                        Obx(() => Text(
                          '${controller.contentLength.value}/3000',
                          style: AppTextStyles.caption(
                            textColor: controller.contentLength.value >= 3000
                                ? AppColors.red
                                : AppColors.gray60,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 고정 버튼
          Padding(
            padding: AppPadding.textField,
            child: SizedBox(
              height:AppSpacing.s52,
              width: double.infinity,
              child: Obx(() => CustomButton(
                text: '커뮤니티에 게시',
                variant: ButtonVariant.primary,
                enabled: controller.isFormValid.value,
              )),
            ),
          ),
        ],
      ),
    );
  }
}