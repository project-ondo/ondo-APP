import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/component_variants.dart';
import '../../../../core/design_system/components/custom_button.dart';

class NextButton extends StatelessWidget {
  final bool? isAgreementChecked;
  final String? text;
  final VoidCallback? onPressed;

  const NextButton({
    super.key,
    this.isAgreementChecked,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: text ?? '다음',
          variant: ButtonVariant.primary,
          enabled: isAgreementChecked ?? false,
          onPressed: onPressed ?? (){
            log('이동');
          },
        ),
        AppGap.v16,
      ],
    );
  }
}
