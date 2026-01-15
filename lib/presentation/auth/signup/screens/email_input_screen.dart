import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ondo/core/design_system/app_strings.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/components/custom_textfield.dart';
import '../../../../core/ui/base/base_scaffold.dart';

import '../controllers/email_input_controller.dart';
import '../widgets/login_back_button.dart';
import '../widgets/next_button.dart';
import '../widgets/title_text.dart';


class EmailInputScreen extends GetView<EmailInputController> {
  const EmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EmailInputController());

    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopSection(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v16,
        LoginBackButton(onTap: Get.back),
        const SizedBox(height: 36),
        TitleText.titleText(AppStrings.emailInputTitle),
        AppGap.v24,
        _buildEmailField(),
      ],
    );
  }

  Widget _buildEmailField() {
    return GetBuilder<EmailInputController>(
      builder: (controller) {
        return LabelTextField(
          label: '이메일',
          controller: controller.emailTextController,
          hintText: AppStrings.emailInputHint,
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailState == EmailInputState.invalid
              ? AppStrings.invalidEmailFormat
              : null,
          onChanged: (_) => controller.resetState(),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return GetBuilder<EmailInputController>(
      builder: (controller) {
        return NextButton(
          isAgreementChecked: controller.hasEmailInput,
          onPressed: _onNextPressed,
        );
      },
    );
  }

  void _onNextPressed() {
    final email = controller.emailTextController.text.trim();

    if (controller.validateEmail(email)) {
      log('이메일 통과: $email');
      // Get.to(() => const NextSignupScreen());
    }
  }
}
