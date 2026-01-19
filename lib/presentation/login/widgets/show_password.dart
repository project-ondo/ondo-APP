import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/login/controllers/login_controller.dart';

class ShowPassword extends StatelessWidget { // 비밀번호 표시 버튼
  ShowPassword({super.key});

  final LoginController controller = Get.find<LoginController>();

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
                  ? 'assets/image/check_on.svg'
                  : 'assets/image/check.svg',
              height: 20,
              width: 20,
            ),
            SizedBox(width: AppSpacing.s8),
            Text(
              '비밀번호 표시',
              style: AppTextStyles.textMedium(
                textColor: controller.showPassword.value
                    ? AppColors.primary
                    : Color(0xffB2B2B2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
