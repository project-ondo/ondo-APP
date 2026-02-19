import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_layout.dart';
import '../../../core/design_system/app_text_styles.dart';

class BuildAppVersionSession extends StatelessWidget {
  const BuildAppVersionSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: AppPadding.settingSession,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "앱버젼",
            style: AppTextStyles.textMedium(
              textColor: AppColors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "4.56",
                style: AppTextStyles.textMedium(
                  textColor: AppColors.gray40,
                ),
              ),
              Text(
                "최신 버전을 사용중입니다",
                style: AppTextStyles.textMedium(
                  textColor: AppColors.gray40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
