import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/app_strings.dart';

class TermsAgreementCard {
  static Container termsAgreementCard = Container(
    padding: EdgeInsets.all(AppSpacing.s16),
    decoration: BoxDecoration(
      color: AppColors.gray20,
      borderRadius: AppRadius.baseRadius,
    ),
    child: Text(AppStrings.privacyAgreementContent,
      style: TextStyle(
        color: AppColors.gray90,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
