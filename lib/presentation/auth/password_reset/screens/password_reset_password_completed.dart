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
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_completed_controller.dart';

class PasswordResetCompletedScreen
    extends GetView<PasswordResetCompletedController> {
  const PasswordResetCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.titleTextHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v51,
            Text(
              '${controller.email}(으)로 회원가입된 계정의',
              style: AppTextStyles.caption(textColor: AppColors.gray70),
            ),
            AppGap.v8,
            Text(
              AppStrings.passwordResetCompleted,
              style: AppTextStyles.titleSm(textColor: AppColors.gray90),
            ),
            Spacer(flex: 1),
            Column(
              children: [
                CustomButton(
                  text: '로그인으로',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    context.go(RoutePaths.login);
                  },
                ),
                AppGap.v16,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
