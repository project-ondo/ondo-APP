import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

void main() {
  runApp(
    MaterialApp(
      home: MajorInterestSetupScreen(),
    ),
  );
}

class MajorInterestSetupScreen extends StatelessWidget {
  const MajorInterestSetupScreen({super.key});

  static const List<String> categories = [
    'FrontEnd',
    'BackEnd',
    'AI',
    'devops',
    '기획',
    'UI/UX',
    'Android',
    'ios',
    'Cloud',
  ];

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
                  TitleText.titleText(
                    AppStrings.majorInterestSelectionTitle,
                  ),
                  AppGap.v36,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전공',
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.gray80,
                        ),
                      ),
                      AppGap.v4,
                      Wrap(
                        spacing: AppSpacing.s16,
                        runSpacing: AppSpacing.s12,
                        children: categories.map(
                          (label) {
                            return SelectableTag(
                              label: label,
                              isSelected: true,
                            );
                          },
                        ).toList(),
                      ),
                      AppGap.v24,
                      Text(
                        '관심분야',
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.gray80,
                        ),
                      ),
                      AppGap.v4,
                      Wrap(
                        spacing: AppSpacing.s16,
                        runSpacing: AppSpacing.s12,
                        children: categories.map(
                          (label) {
                            return SelectableTag(
                              label: label,
                              isSelected: true,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    text: '다음',
                    variant: ButtonVariant.primary,
                  ),
                  AppGap.v16,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableTag extends StatelessWidget {
  final String label;
  final bool isSelected;

  const SelectableTag({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.gray20 : AppColors.primary,
        borderRadius: AppRadius.baseRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.textMedium(
          textColor: isSelected ? AppColors.black : AppColors.white,
        ),
      ),
    );
  }
}
