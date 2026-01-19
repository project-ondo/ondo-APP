import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import '../../../../core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

void main() {
  runApp(
    MaterialApp(
      home: NicknameSetupScreen(),
    ),
  );
}

class NicknameSetupScreen extends StatefulWidget {
  const NicknameSetupScreen({super.key});

  @override
  State<NicknameSetupScreen> createState() => _NicknameSetupScreenState();
}

TextEditingController controller = TextEditingController();

class _NicknameSetupScreenState extends State<NicknameSetupScreen> {
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
                  AppGap.v76,
                  Text(
                    AppStrings.nicknameInputTitle,
                    style: AppTextStyles.titleSm(),
                  ),
                  AppGap.v8,
                  Text(
                    AppStrings.nicknameImmutableWarning,
                    style: AppTextStyles.caption(textColor: AppColors.gray70),
                  ),
                  AppGap.v24,
                  LabelTextField(
                    label: '닉네임',
                    controller: controller,
                    hintText: '닉네임을 입력해주세요',
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    text: '닉네임 확정',
                    variant: ButtonVariant.primary,
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
