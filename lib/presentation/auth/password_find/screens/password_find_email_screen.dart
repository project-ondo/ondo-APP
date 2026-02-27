import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/password_find/controllers/password_find_controller.dart';
import 'package:get/get.dart';



class PasswordFindEmailScreen extends GetView<ForgotPasswordController> {
  final bool isError;

  const PasswordFindEmailScreen({
    super.key,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.titleTextHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGap.v16,
              LoginBackButton(onTap: () => Get.back()),
              AppGap.v36,
              Text(
                AppStrings.passwordResetEmail,
                style: AppTextStyles.titleSm(),
              ),
              AppGap.v36,
              Obx(
                    () => LabelTextField(
                  label: '이메일',
                  controller: controller.emailController,
                  hintText: '이메일을 입력해주세요.',
                  isError: controller.errorMsg.value.isNotEmpty,
                  errorText: controller.errorMsg.value.isEmpty
                      ? null
                      : controller.errorMsg.value,
                ),
              ),
              const Spacer(),
              Obx(
                    () => CustomButton(
                  text: '인증번호 발송',
                  variant: ButtonVariant.primary,
                  enabled: controller.isEmailValid.value,
                  onPressed: controller.isEmailValid.value
                      ? () => controller.sendVerificationCode()
                      : null,
                ),
              ),
              AppGap.v16
            ],
          ),
        ),
      ),
    );
  }
}

