import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/presentation/auth/signup/controllers/nickname_input_controller.dart';
import '../../../../core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

class NicknameSetupScreen extends GetView<NicknameInputController> {
  const NicknameSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildForm(),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v76,
        Text(
          AppStrings.nicknameInputTitle,
          style: AppTextStyles.titleSm(),
        ),
        AppGap.v8,
        Text(
          AppStrings.nicknameImmutableWarning,
          style: AppTextStyles.caption(textColor: AppColors.gray70),
        ),
        AppGap.v24,

        LabelTextField(
          label: '닉네임',
          controller: controller.nicknameController,
          hintText: '닉네임을 입력해주세요',
          errorText: controller.errorText,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<NicknameInputController>(
      builder: (controller) {
        return Column(
          children: [
            CustomButton(
              text: '닉네임 확정',
              variant: ButtonVariant.primary,
              enabled: controller.conSubmit,
              onPressed: controller.conSubmit
                  ? () {
                      final valid = controller.validateNickname();
                      if (!valid) return;
                      log(controller.nicknameController.text);
                      context.pushNamed('signupProfileImage');
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
