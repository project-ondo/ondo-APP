import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/presentation/auth/signup/states/input_validation_state.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/components/custom_textfield.dart';
import '../../../../core/ui/base/base_scaffold.dart';

import '../controllers/signup_email_input_controller.dart';
import '../widgets/login_back_button.dart';
import '../widgets/next_button.dart';
import '../widgets/title_text.dart';

class SignupEmailInputScreen extends GetView<SignupEmailInputController> {
  const SignupEmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopSection(context),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v16,
        LoginBackButton(onTap: () => context.goNamed('login')),
        AppGap.v36,
        TitleText.titleText(AppStrings.emailInputTitle),
        AppGap.v24,
        _buildEmailField(),
      ],
    );
  }

  Widget _buildEmailField() {
    return GetBuilder<SignupEmailInputController>(
      builder: (controller) {
        return LabelTextField(
          label: '이메일',
          controller: controller.emailTextController,
          hintText: AppStrings.emailInputHint,
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailState == InputValidationState.invalid
              ? AppStrings.invalidEmailFormat
              : null,
        );
      },
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GetBuilder<SignupEmailInputController>(
      builder: (controller) {
        return NextButton(
          isAgreementChecked: controller.hasEmailInput,
          onPressed: controller.hasEmailInput
              ? () => _onNextPressed(context)
              : null,
        );
      },
    );
  }

  void _onNextPressed(BuildContext context) {
    final email = controller.emailTextController.text.trim();

    if (controller.validateEmail(email)) {
      context.pushNamed('signupEmailCode');
    }
  }
}
