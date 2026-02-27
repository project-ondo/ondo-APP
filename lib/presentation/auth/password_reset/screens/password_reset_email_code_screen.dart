import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_email_code_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';


class PasswordResetEmailCodeInputScreen
    extends GetView<PasswordResetEmailCodeController> {
  const PasswordResetEmailCodeInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.titleTextHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppGap.v16,
                  LoginBackButton(onTap: Get.back),
                  AppGap.v36,
                  TitleText.titleText(AppStrings.emailCodeInputTitle),
                  AppGap.v24,
                  Text('이메일', style: AppTextStyles.textMedium()),
                  AppGap.v4,
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.gray20,
                      borderRadius: AppRadius.baseRadius,
                    ),
                    padding: AppPadding.textField,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.passwordResetEmail,
                      style: AppTextStyles.textMedium(
                        textColor: AppColors.gray60,
                      ),
                    ),
                  ),
                  AppGap.v24,
                  GetBuilder<PasswordResetEmailCodeController>(
                    builder: (controller) {
                      return LabelTextField(
                        label: '인증번호',
                        keyboardType: TextInputType.number,
                        controller: controller.passwordResetCodeInputController,
                        hintText: AppStrings.emailCodeInputHint,
                        errorText: controller.passwordResetHasError
                            ? controller.passwordResetErrorMessage
                            : null,
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        log('이메일 입력 페이지로 이동');
                      },
                      child: Text(
                        '다른 이메일을 입력하시고 싶나요?',
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.gray50,
                        ),
                      ),
                    ),
                  ),
                  AppGap.v16,
                  GetBuilder<PasswordResetEmailCodeController>(
                    builder: (controller) {
                      return CustomButton(
                        text: '인증하기',
                        variant: ButtonVariant.primary,
                        enabled: controller.passwordResetIsButtonEnabled,
                        onPressed: controller.passwordResetIsButtonEnabled
                            ? controller.passwordResetVerifyEmailCode
                            : null,
                      );
                    },
                  ),
                  AppGap.v16,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
