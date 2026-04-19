import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

class SignupCompleteScreen extends GetView<SignupFlowController> {
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
              _buildContent(),
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v51,
        Text(
          '*닉네임 ${controller.nickname ?? ''}로 회원가입되었어요!',
          style: AppTextStyles.caption(textColor: AppColors.gray70),
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
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          CustomButton(
            text: '시작하기',
            variant: ButtonVariant.primary,
            enabled: !controller.isLoading.value,
            onPressed: controller.isLoading.value
                ? null
                : () async {
              final success = await controller.submitInfo();
              if (!context.mounted) return;

              if (!success) {
                Get.snackbar(
                  '회원가입 실패',
                  '회원가입에 실패했습니다. 다시 시도해주세요.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // 프로필 이미지 경로 임시 저장 (로그인 후 업로드)
              final imagePath = controller.profileImagePath;
              controller.clear();

              await LoginController.savePendingProfileImage(imagePath);
              if (!context.mounted) return;

              context.go(RoutePaths.login);
            },
          ),
          AppGap.v16,
        ],
      ),
    );
  }
}