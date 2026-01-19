import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/login/controllers/login_controller.dart';
import 'package:ondo/presentation/login/widgets/auth_link.dart';
import 'package:ondo/presentation/login/widgets/show_password.dart';



class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Image.asset('assets/image/logo.png'),
                SizedBox(height: 70),
                Obx(
                      () =>
                      LabelTextField(
                        label: '이메일',
                        hintText: '이메일을 입력해주세요.',
                        isError: controller.hasError.value,
                        controller: controller.emailController,
                      ),
                ),
                SizedBox(height: AppSpacing.s8),
                Obx(
                      () =>
                      LabelTextField(
                        label: '비밀번호',
                        hintText: '비밀번호를 입력해주세요',
                        controller: controller.passwordController,
                        obscureText: !controller.showPassword.value,
                        isError: controller.hasError.value,
                        errorText: controller.errorMsg.value.isEmpty
                            ? null
                            : controller.errorMsg.value,
                      ),
                ),
                const SizedBox(height: AppSpacing.s8),
                ShowPassword(),
              ],
            ),
          ),
          Spacer(flex: 1),
          AuthLink(),
          SizedBox(height: AppSpacing.s8),
          SizedBox(
            height: 52,
            width: 364,
            child: CustomButton(
              text: '로그인',
              variant: ButtonVariant.primary,
              onPressed: controller.login,
            ),
          ),
          SizedBox(height: AppSpacing.s24),
        ],
      ),


    );
  }
}
  void main() {
    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
}

