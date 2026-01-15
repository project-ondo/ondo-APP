import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: appRouter,
    ),
  );
}

class EmailCodeInputScreen extends StatefulWidget {
  const EmailCodeInputScreen({super.key});

  @override
  State<EmailCodeInputScreen> createState() => _EmailCodeInputScreenState();
}

TextEditingController emailCodeController = TextEditingController();

class _EmailCodeInputScreenState extends State<EmailCodeInputScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppGap.v16,
                  LoginBackButton(onTap: Get.back),
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
                      AppStrings.emailInputHint,
                      style: AppTextStyles.textMedium(
                        textColor: AppColors.gray60,
                      ),
                    ),
                  ),
                  AppGap.v24,
                  LabelTextField(
                    label: '인증번호',
                    controller: emailCodeController,
                    hintText: '인증번호를 입력해주세요',
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
                  CustomButton(
                    text: '인증하기',
                    variant: ButtonVariant.primary,onPressed: () {
                      log('이메일 인증');
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
