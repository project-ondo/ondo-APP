import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/password_find/controllers/password_find_password_controller.dart';
import '../../../../core/design_system/app_icon.dart';

class PasswordResetCompleted extends StatelessWidget {
  final PasswordResetController controller;

  const PasswordResetCompleted({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: _buildForm(),
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGap.v76,
          Text(
            AppStrings.passwordResetPassword,
            style: AppTextStyles.titleSm(),
          ),
          AppGap.v36,
          LabelTextField(
            label: '비밀번호',
            controller: controller.passwordController,
            hintText: AppStrings.passwordInputHint,
            obscureText: controller.isObscure.value,
            errorText: controller.passwordErrorText,
          ),
          AppGap.v24,
          LabelTextField(
            label: '비밀번호 확인',
            controller: controller.confirmPasswordController,
            hintText: AppStrings.passwordCheckHint,
            obscureText: controller.isObscure.value,
            errorText: controller.confirmPasswordErrorText,
          ),
          AppGap.v8,
          _buildPasswordToggle(),
        ],
      );
    });
  }

  Widget _buildPasswordToggle() {
    return Obx(() {
      return GestureDetector(
        onTap: controller.toggleObscure,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                controller.isObscure.value
                    ? AppIcon.check.path
                    : AppIcon.checkOn.path,
              ),
              AppGap.h6,
              Text(
                '비밀번호 표시',
                style: AppTextStyles.textMedium(
                  textColor: controller.isObscure.value
                      ? AppColors.gray50
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNextButton() {
    return Obx(() {
      return Column(
        children: [
          CustomButton(
            text: '다음',
            variant: ButtonVariant.primary,
            enabled: controller.hasInput.value,
            onPressed: () {
              controller.submit();
              if (controller.canProceed) {
                _handleNext();
              }
            },
          ),
          AppGap.v16,
        ],
      );
    });
  }

  void _handleNext() {
    assert(() {
      log('비밀번호 설정 완료');
      return true;
    }());

    // context.push('/next');
  }
}
