import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_image_section.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_tag_section.dart';

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

  void toggleTag(Set<String> targetSet, String tag) {
    setState(() {
      if (targetSet.contains(tag)) {
        targetSet.remove(tag);
      } else {
        targetSet.add(tag);
      }
    });
  }

  @override
  void dispose() {
    nickNameController.dispose();
    introductionController.dispose();
    super.dispose();
  }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ProfileImageSection(),
                      AppGap.v24,

                      LabelTextField(
                        label: '닉네임',
                        controller: nickNameController,
                        hintText: '닉네임을 입력해주세요',
                      ),
                      AppGap.v24,

                      LabelTextField(
                        label: '닉네임',
                        controller: introductionController,
                        hintText: '닉네임을 입력해주세요',
                        minLines: 4,
                        maxLines: 4,
                      ),
                      AppGap.v24,

                      ProfileTagSection(
                        title: "전공",
                        tags: majorTags,
                        selectedTags: selectedMajors,
                        onTagToggle: (tag) => toggleTag(selectedMajors, tag),
                      ),
                      AppGap.v24,

                      ProfileTagSection(
                        title: "관심분야",
                        tags: interestTags,
                        selectedTags: selectedInterests,
                        onTagToggle: (tag) => toggleTag(selectedInterests, tag),
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
                  //context.push(RoutePaths.myProfile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
