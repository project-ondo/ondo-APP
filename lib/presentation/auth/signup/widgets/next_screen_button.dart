import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/component_variants.dart';
import '../../../../core/design_system/components/custom_button.dart';

class NextScreenButton extends StatelessWidget {
  final bool? isAgreementChecked;

  const NextScreenButton({
    super.key,
    this.isAgreementChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: '다음',
          variant: ButtonVariant.primary,
          enabled: isAgreementChecked ?? false,
          onPressed: () {
            log('이동');
          },
        ),
        AppGap.v16,
      ],
    );
  }
}
