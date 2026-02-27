import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/router/app_router.dart';

class AuthLink extends StatelessWidget {
  const AuthLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            context.go(RoutePaths.passwordReset);
          },
          child: Text(
            '비밀번호 찾기',
            style: AppTextStyles.textMedium(textColor: AppColors.gray),
          ),
        ),
        SizedBox(
          height: 16,
          child: VerticalDivider(
            thickness: 1,
            width: 20,
            color: AppColors.gray,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(RoutePaths.signupTerms);
          },
          child: Text(
            '회원가입',
            style: AppTextStyles.textMedium(textColor: AppColors.gray),
          ),
        ),
      ],
    );
  }
}
