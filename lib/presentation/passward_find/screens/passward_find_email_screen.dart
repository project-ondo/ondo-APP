import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/passward_find/controllers/passward_find_controller.dart';
import 'package:get/get.dart';

void main() async {
  runApp(
    MaterialApp(
      home: PasswardFindEmailScreen(),
    ),
  );
}

class PasswardFindEmailScreen extends StatefulWidget {
  final bool isError;

  const PasswardFindEmailScreen({super.key, this.isError = false,
  });

  @override
  State<PasswardFindEmailScreen> createState() =>
      _PasswardFindEmailScreenState();
}

class _PasswardFindEmailScreenState extends State<PasswardFindEmailScreen> {
  final controller = Get.put(ForgotPasswordController());


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGap.v16,
              LoginBackButton(onTap: () {}),
              AppGap.v36,
              Text(
                '계정에 등록된\n이메일을 입력해주세요',
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
                  onPressed: () {
                    if (controller.validateEmail()) {
                      debugPrint('인증번호 발송');
                    }
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(bottom: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
