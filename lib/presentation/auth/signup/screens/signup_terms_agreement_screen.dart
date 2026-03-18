import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_terms_agreement_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/agreement_checkbox.dart';
import 'package:ondo/presentation/auth/signup/widgets/login_back_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/next_button.dart';
import 'package:ondo/presentation/auth/signup/widgets/terms_agreement_card.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

class SignupTermsAgreementScreen extends GetView<SignupTermsAgreementController> {
  const SignupTermsAgreementScreen({super.key});

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
                    onTap: () => context.pop(),
                  ),

                  AppGap.v36,
                  TitleText.titleText(AppStrings.agreementTitle),

                  AppGap.v24,
                  TermsAgreementCard.termsAgreementCard,

                  AppGap.v16,
                  //check box
                  Obx(
                    () => AgreementCheckbox(
                      isChecked: controller.isAgreementChecked.value,
                      onTap: controller.toggleAgreement,
                    ),
                  ),
                ],
              ),

              Obx(
                () => NextButton(
                  isAgreementChecked: controller.canProceed,
                  onPressed: () => context.goNamed('signupEmail'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
