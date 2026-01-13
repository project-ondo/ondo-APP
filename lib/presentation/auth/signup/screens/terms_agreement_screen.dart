import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/agreement_checkbox.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/next_screen_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/terms_agreement_card.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

void main() {
  runApp(MaterialApp(home: TermsAgreementScreen()));
}

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

bool isAgreementChecked = false;

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
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
            children: [
            AppGap.v24,
            LoginBackButton(
              onTap: () {
                log('로그인으로 이동');
              },
            ),

            SizedBox(height: 36),
            TitleText.titleText(
              '온도에 오신 것을 환영합니다! \n개인정보 수집 및 이용에 동의해주세요',
            ),

            AppGap.v24,
            TermsAgreementCard.termsAgreementCard,

            AppGap.v16,
            //check box
            AgreementCheckbox(
              isChecked: isAgreementChecked,
              onTap: () {
                log('check');
                setState(() {
                  isAgreementChecked = !isAgreementChecked;
                });
              },
            ),
            ],
          ),

          Column(
            children: [
              CustomButton(
                text: '다음',
                variant: ButtonVariant.primary,
                enabled: isAgreementChecked,
                onPressed: () {
                  log('이동');
                },
              ),
              AppGap.v16,
            ],
          ),
          NextScreenButton(isAgreementChecked: isAgreementChecked,),
          ],
        ),
      ),
    ),);
  }
}
