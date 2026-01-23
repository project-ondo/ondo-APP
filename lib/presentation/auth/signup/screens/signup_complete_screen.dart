import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

void main() {
  runApp(
    MaterialApp(
      home: SignupCompleteScreen(),
    ),
  );
}

class SignupCompleteScreen extends StatelessWidget {
  const SignupCompleteScreen({super.key});

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
                  AppGap.v51,
                  Text(
                    '*닉네임 KIEYU로 회원가입되었어요!',
                    style: AppTextStyles.caption(
                      textColor: AppColors.gray70,
                    ),
                  ),
                  AppGap.v8,
                  TitleText.titleText(AppStrings.signupCompletionTitle),
                  AppGap.v24,
                  Text(
                    AppStrings.guidelineAvoidSevereCriticism,
                    style: AppTextStyles.textMedium(),
                  ),
                  AppGap.v12,
                  Text(
                    AppStrings.guidelineRespectOthers,
                    style: AppTextStyles.textMedium(),
                  ),
                  AppGap.v12,
                  Text(
                    AppStrings.guidelineAvoidProblematicRemarks,
                    style: AppTextStyles.textMedium(),
                  ),
                  AppGap.v12,
                  Text(
                    AppStrings.ruleViolationWarning,
                    style: AppTextStyles.textMedium(textColor: AppColors.red),
                  ),
                ],
              ),
              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Column(
      children: [
        CustomButton(
          text: '시작하기',
          variant: ButtonVariant.primary,
        ),
        AppGap.v16,
      ],
    );
  }
}
