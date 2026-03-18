import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';

class ShowPassword extends StatelessWidget {
  const ShowPassword({super.key, required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () =>
            controller.showPassword.value = !controller.showPassword.value,
        child: Row(
          children: [
            SvgPicture.asset(
              controller.showPassword.value
                  ? AppIcon.checkOn.path
                  : AppIcon.check.path,
              height: 20,
              width: 20,
            ),
            AppGap.h8,
            Text(
              '비밀번호 표시',
              style: AppTextStyles.textMedium(
                textColor: controller.showPassword.value
                    ? AppColors.primary
                    : AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
