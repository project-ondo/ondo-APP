import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_image_section.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_tag_section.dart';

void main() {
  runApp(
    MaterialApp(
      home: EditProfileScreen(),
    ),
  );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nickNameController = TextEditingController(
    text: "기존 닉네임",
  );
  final TextEditingController introductionController = TextEditingController(
    text: "기존 소개글",
  );

  final List<String> majorTags = [
    "FrontEnd",
    "BackEnd",
    "AI",
    "devops",
    "기획",
    "UI/UX",
    "Android",
    "ios",
    "Cloud",
  ];
  final List<String> interestTags = [
    "FrontEnd",
    "BackEnd",
    "AI",
    "devops",
    "기획",
    "UI/UX",
    "Android",
    "ios",
    "Cloud",
  ];

  final Set<String> selectedMajors = {"UI/UX"};
  final Set<String> selectedInterests = {"AI"};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomBackButton(moreOptions: false),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppPadding.screenHorizontal,
                  child: Column(
                    children: [
                      ProfileImageSection(),
                      AppGap.v24,
                      nickNameTextField(),
                      AppGap.v24,
                      introductionTextField(),
                      AppGap.v24,
                      ProfileTagSection(
                        title: "전공",
                        tags: majorTags,
                        selectedTags: selectedMajors,
                      ),
                      AppGap.v24,
                      ProfileTagSection(
                        title: "관심분야",
                        tags: interestTags,
                        selectedTags: selectedInterests,
                      ),
                      AppGap.v24,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: AppPadding.settingSession,
              child: CustomButton(
                text: "변경 완료",
                variant: ButtonVariant.primary,
                onPressed: () {
                  log(nickNameController.text);
                  log(introductionController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nickNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "닉네임",
          style: AppTextStyles.textMedium(textColor: AppColors.gray80),
        ),
        AppGap.v4,
        CustomTextField(
          controller: nickNameController,
          hintText: "닉네임을 입력해주세요",
        ),
      ],
    );
  }

  Widget introductionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "소개글",
          style: AppTextStyles.textMedium(textColor: AppColors.gray80),
        ),
        AppGap.v4,
        CustomTextField(
          controller: introductionController,
          hintText: "간단히 소개글을 입력해주세요",
          minLines: 4,
          maxLines: 4,
        ),
      ],
    );
  }

}
