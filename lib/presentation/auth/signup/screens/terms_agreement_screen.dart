import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/terms_agreement_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/agreement_checkbox.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/next_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/terms_agreement_card.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';


class TermsAgreementScreen extends StatelessWidget {
   TermsAgreementScreen({super.key});

  final TermsAgreementController termsAgreementController = Get.put(TermsAgreementController());

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

                  AppGap.v36,
                  TitleText.titleText(
                    AppStrings.agreementTitle
                  ),

                  AppGap.v24,
                  TermsAgreementCard.termsAgreementCard,

                  AppGap.v16,
                  //check box
                  Obx(
                    () => AgreementCheckbox(
                      isChecked: termsAgreementController.isAgreementChecked.value,
                      onTap: termsAgreementController.toggleAgreement,
                    ),
                  ),
                ],
              ),

              Obx(
                () => NextButton(
                  isAgreementChecked: termsAgreementController.canProceed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
