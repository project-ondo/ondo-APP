import 'package:flutter/cupertino.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

import '../../../core/design_system/app_colors.dart';

class UserIntroductionText extends StatelessWidget {
  const UserIntroductionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      '안녕하세요! 이제 1년차 다 되어가는 UI/UX 디자이너\n김유찬입니다!',
      style: AppTextStyles.profileIntroduction(
        textColor: AppColors.gray90,
      ),
    );
  }
}
