import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

void main() {
  runApp(
    MaterialApp(
      home: ProfileImageSetupScreen(),
    ),
  );
}

class ProfileImageSetupScreen extends StatelessWidget {
  const ProfileImageSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppGap.v76,
                  Text(
                    AppStrings.profileRegistrationTitle,
                    style: AppTextStyles.titleSm(),
                  ),
                  Text(
                    AppStrings.stepSkipHint,
                    style: AppTextStyles.caption(
                      textColor: AppColors.gray70,
                    ),
                  ),
                  AppGap.v40,
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          padding: AppPadding.userCard,
                          child: SvgPicture.asset(AppIcon.defaultProfile.path),
                        ),
                        Container(
                          height: 38,
                          width: 38,
                          margin: EdgeInsets.only(
                            bottom: AppSpacing.s18,
                            right: AppSpacing.s2,
                          ),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: AppColors.primary,
                          ),
                          child: SvgPicture.asset(AppIcon.camera.path),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    text: '다음',
                    variant: ButtonVariant.primary,
                  ),
                  AppGap.v16
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
