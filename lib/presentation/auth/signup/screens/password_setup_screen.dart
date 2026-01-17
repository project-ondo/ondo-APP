import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

import '../../../../core/design_system/app_icon.dart';

void main() {
  runApp(
    MaterialApp(
      home: PasswordSetupScreen(),
    ),
  );
}

class PasswordSetupScreen extends StatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

TextEditingController controller = TextEditingController();
TextEditingController controller1 = TextEditingController();

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppGap.v76,
                  Text(
                    AppStrings.emailPasswordInputTitle,
                    style: AppTextStyles.titleSm(),
                  ),
                  AppGap.v36,
                  LabelTextField(
                    label: '비밀번호',
                    controller: controller,
                    hintText: AppStrings.passwordInputHint,
                  ),
                  AppGap.v24,
                  LabelTextField(
                    label: '비밀번호 확인',
                    controller: controller1,
                    hintText: AppStrings.passwordCheckHint,
                    errorText: AppStrings.invalidPassword,
                  ),
                  AppGap.v8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppIcon.checkOn.path),
                      AppGap.h6,
                      Text(
                        '비밀번호 표시',
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    text: '다음',
                    variant: ButtonVariant.primary,
                  ),
                  AppGap.v16
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
