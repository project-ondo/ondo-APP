import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_introduction_input_controller.dart';

import '../widgets/title_text.dart';

class SignupIntroductionInputScreen extends GetView<SignupIntroductionInputController> {
  const SignupIntroductionInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputIntroductionSection(),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputIntroductionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v76,
        TitleText.titleText(AppStrings.selfIntroductionTitle),
        AppGap.v36,
        GetBuilder<SignupIntroductionInputController>(
          builder: (controller) {
            return LabelTextField(
              label: '자기소개',
              controller: controller.introductionController,
              hintText: AppStrings.selfIntroductionHint,
              isError: controller.hasError,
              errorText: controller.errorText,
              maxLines: 6,
              minLines: 4,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GetBuilder<SignupIntroductionInputController>(
      builder: (controller) {
        return Column(
          children: [
            CustomButton(
              text: '다음',
              variant: ButtonVariant.primary,
              enabled: controller.canProceed,
              onPressed: controller.canProceed
                  ? () {
                      controller.submit();
                      context.pushNamed('signupMajorInterest');
                    }
                  : null,
            ),
            AppGap.v16,
          ],
        );
      },
    );
  }
}
