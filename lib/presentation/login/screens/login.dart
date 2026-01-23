import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_icon.dart';
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
            padding: AppPadding.textField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Image.asset(AppIcon.logo.path),
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
                AppGap.v8,
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
                AppGap.v8,
                ShowPassword(),
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
              onPressed: controller.login,
            ),
          ),
          AppGap.v24
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

