import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/controllers/edit_profile_controller.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_image_section.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_tag_section.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nickNameController = TextEditingController(
      text: controller.displayName.value,
    );
    final introductionController = TextEditingController(
      text: controller.bio.value,
    );

    return SafeArea(
      child: BaseScaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: const CustomBackButton(moreOptions: false),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppPadding.screenHorizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => ProfileImageSection(
                        imagePath: controller.selectedImage.value?.path,
                        imageUrl: null, // TODO: 프로필 이미지 URL 연동
                        onPickImage: controller.pickImage,
                        onRemoveImage: controller.removeImage,
                      )),
                      AppGap.v24,

                      LabelTextField(
                        label: '닉네임',
                        controller: nickNameController,
                        hintText: '닉네임을 입력해주세요',
                      ),
                      AppGap.v24,

                      LabelTextField(
                        label: '소개글',
                        controller: introductionController,
                        hintText: '간단히 소개글을 입력해주세요',
                        minLines: 4,
                        maxLines: 4,
                      ),
                      AppGap.v24,

                      Obx(() => ProfileTagSection(
                        title: '전공',
                        tags: controller.tags,
                        selectedTags: {controller.selectedMajor.value},
                        onTagToggle: (tag) => controller.selectMajor(tag),
                      )),
                      AppGap.v24,

                      Obx(() => ProfileTagSection(
                        title: '관심분야',
                        tags: controller.tags,
                        selectedTags: controller.selectedInterests.toSet(),
                        onTagToggle: (tag) => controller.toggleInterest(tag),
                      )),

                      AppGap.v24,
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => Padding(
              padding: AppPadding.settingSession,
              child: CustomButton(
                text: '변경 완료',
                variant: ButtonVariant.primary,
                enabled: !controller.isLoading.value,
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                  final success = await controller.saveProfile(
                    displayName: nickNameController.text.trim(),
                    bio: introductionController.text.trim(),
                  );
                  if (success && context.mounted) {
                    context.pop();
                  }
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}