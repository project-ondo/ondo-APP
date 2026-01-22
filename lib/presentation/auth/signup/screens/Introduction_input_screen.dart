import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

import '../widgets/title_text.dart';

void main(){
  runApp(MaterialApp(home: IntroductionInputScreen(),));
}

class IntroductionInputScreen extends StatelessWidget {
  const IntroductionInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
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
                  TitleText.titleText(AppStrings.selfIntroductionTitle),
                  AppGap.v36,
                  LabelTextField(
                    label: '자기소개',
                    controller: controller,
                    hintText: AppStrings.selfIntroductionHint,
                    maxLines: 6,
                    minLines: 4,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(text: '다음', variant: ButtonVariant.primary),
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
