import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';

import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/components/custom_textfield.dart';
import '../../../../core/ui/base/base_scaffold.dart';
import '../widgets/login_back_button.dart';
import '../widgets/next_button.dart';
import '../widgets/title_text.dart';

void main() {
  runApp(
    MaterialApp(
      home: EmailInputScreen(),
    ),
  );
}

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

final TextEditingController controller = TextEditingController();

class _EmailInputScreenState extends State<EmailInputScreen> {
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
                  AppGap.v16,
                  LoginBackButton(
                    onTap: () {
                      log('로그인으로');
                    },
                  ),
                  SizedBox(height: 36),
                  TitleText.titleText(
                    '계정 인증을 위해 \n이메일을 입력해주세요',
                  ),
                  AppGap.v24,
                  LabelTextField(
                    label: '이메일',
                    controller: controller,
                    hintText: '이메일을 입력해주세요',
                  ),
                ],
              ),
              NextButton(
                text: '인증번호 발송',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
