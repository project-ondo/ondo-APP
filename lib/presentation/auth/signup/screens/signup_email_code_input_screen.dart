import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_email_code_input_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

class SignupEmailCodeInputScreen
    extends GetView<SignupEmailCodeInputController> {
  const SignupEmailCodeInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppGap.v16,
                      LoginBackButton(
                        onTap: () => context.pushReplacementNamed('login'),
                      ),
                      AppGap.v36,
                      TitleText.titleText(AppStrings.emailInputTitle),
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
                          controller.email,
                          style: AppTextStyles.textMedium(
                            textColor: AppColors.gray60,
                          ),
                        ),
                      ),
                      AppGap.v24,
                      Obx(
                            () => LabelTextField(
                          label: '인증번호',
                          keyboardType: TextInputType.number,
                          controller: controller.emailCodeTextController,
                          hintText: AppStrings.emailCodeInputHint,
                          errorText: controller.hasError
                              ? controller.errorMessage
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        '다른 이메일을 입력하시고 싶나요?',
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.gray50,
                        ),
                      ),
                    ),
                  ),
                  AppGap.v16,
                  Obx(
                        () {
                      final isEnabled =
                          controller.isButtonEnabled &&
                              !controller.isLoading.value;

                      return CustomButton(
                        text: '인증하기',
                        variant: ButtonVariant.primary,
                        enabled: isEnabled,
                        onPressed: isEnabled
                            ? () async {
                          FocusScope.of(context).unfocus();

                          final result = await controller
                              .verifyEmailCode();
                          if(!context.mounted) return;
                          if (result) {
                            context.pushNamed('signupPassword');
                          }
                        }
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
