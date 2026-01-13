import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class AgreementCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;

  const AgreementCheckbox({
    super.key,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            isChecked ? AppIcon.checkOn.path : AppIcon.check.path,
          ),
          const SizedBox(width: 6),
          Text(
            '[개인정보 수집 및 이용 동의] (필수)',
            style: AppTextStyles.textMedium(
              textColor: isChecked ? AppColors.primary : Color(0xffB2B2B2),
            ),
          ),
        ],
      ),
    );
  }
}
