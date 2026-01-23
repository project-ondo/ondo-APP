import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/major_interest_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';


//테스트용 코드 route작업시 삭제
//---------------------------------------
void main() {
    Get.put(MajorInterestController());
  runApp(
    GetMaterialApp(
      home: MajorInterestSetupScreen(),
    ),
  );
}
//---------------------------------------

class MajorInterestSetupScreen extends GetView<MajorInterestController> {
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
                  _buildMajorSelectSection(categories: categories),

                  AppGap.v24,
                  _buildInterestSection(categories: categories),
                ],
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSection({
    required List<String> categories,
  }) {
    return GetBuilder<MajorInterestController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    isSelected: controller.selectedInterests.contains(label),
                    onTap: () => controller.toggleInterest(label),
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMajorSelectSection({
    required List<String> categories,
  }) {
    return GetBuilder<MajorInterestController>(
      builder: (controller) {
        return Column(
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
                    isSelected: controller.selectedMajor == label,
                    onTap: () => controller.selectMajor(label),
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextButton() {
    return GetBuilder<MajorInterestController>(
      builder: (controller) {
        return Column(
          children: [
            CustomButton(
              text: '다음',
              variant: ButtonVariant.primary,
              enabled: controller.canProceed,
              onPressed: controller.canProceed ? controller.submit : null,
            ),
            AppGap.v16,
          ],
        );
      },
    );
  }
}

class SelectableTag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final GestureTapCallback onTap;

  const SelectableTag({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.chip,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.gray20,
          borderRadius: AppRadius.baseRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.textMedium(
            textColor: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
