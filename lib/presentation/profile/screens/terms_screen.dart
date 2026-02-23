import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: CustomBackButton(moreOptions: false),
            ),
            AppGap.v16,
            Container(
              margin: AppPadding.terms,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: AppPadding.topBar,
                    decoration: BoxDecoration(
                      color: AppColors.gray20,
                      borderRadius: AppRadius.baseRadius,
                    ),
                    child: Text(AppStrings.privacyAgreementContent),
                  ),
                  AppGap.v16,
                  Text(
                    "2026 - 01- 12에 동의한 개인정보 수집 내용입니다",
                    style: AppTextStyles.textMedium(
                      textColor: AppColors.gray50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
