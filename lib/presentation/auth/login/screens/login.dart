import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';
import 'package:ondo/presentation/auth/login/widgets/auth_link.dart';
import 'package:ondo/presentation/auth/login/widgets/show_password.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: AppPadding.textField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Image.asset(AppIcon.logo.path),
                SizedBox(height: 70),
                Obx(
                  () => LabelTextField(
                    label: '이메일',
                    hintText: '이메일을 입력해주세요.',
                    isError: controller.emailError.value != null,
                    errorText: controller.emailError.value,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                AppGap.v8,
                Obx(
                  () => LabelTextField(
                    label: '비밀번호',
                    hintText: '비밀번호를 입력해주세요',
                    controller: controller.passwordController,
                    obscureText: !controller.showPassword.value,
                    isError: controller.passwordError.value != null,
                    errorText: controller.passwordError.value,
                  ),
                ),
                AppGap.v8,
                ShowPassword(controller: controller),
              ],
            ),
          ),
          Spacer(flex: 1),
          AuthLink(),
          AppGap.v8,
          SizedBox(
            height: 52,
            width: 364,
            child: CustomButton(
              text: '로그인',
              variant: ButtonVariant.primary,
              onPressed: () async {
                final success = await controller.login();

                if (!context.mounted) return;

                if (success) {
                  context.go(RoutePaths.home);
                }
              },
            ),
          ),
          AppGap.v24,
        ],
      ),
    );
  }
}
