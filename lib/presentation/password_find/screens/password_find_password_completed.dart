import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

void main() {
  runApp(
    MaterialApp(
      home: PasswordResetCompletedScreen(email: 'bulgom.com'),
    ),
  );
}

class PasswordResetCompletedScreen extends StatelessWidget {
  final String email;

  const PasswordResetCompletedScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v51,
            Text(
              '$email로 회원가입된 계정의',
              style: AppTextStyles.caption(textColor: AppColors.gray70),
            ),
            AppGap.v8,
            Text(
              AppStrings.passwordResetCompleted,
              style: AppTextStyles.titleSm(),
            ),
            Spacer(flex: 1),
            Column(
              children: [
                CustomButton(
                  text: '다음',
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                ),
                AppGap.v16,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
