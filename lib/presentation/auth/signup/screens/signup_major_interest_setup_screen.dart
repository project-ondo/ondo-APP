import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_major_interest_controller.dart';
import 'package:ondo/presentation/auth/signup/widgets/title_text.dart';

class SignupMajorInterestSetupScreen
    extends GetView<SignupMajorInterestController> {
  const SignupMajorInterestSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = MajorCategory.values;

    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                ),
              ),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSection({required List<MajorCategory> categories}) {
    return GetBuilder<SignupMajorInterestController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '관심분야',
              style: AppTextStyles.textMedium(textColor: AppColors.gray80),
            ),
            AppGap.v4,
            Wrap(
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s12,
              children: categories.map((category) {
                return SelectableTag(
                  label: category.label,
                  isSelected: controller.selectedInterests.contains(category),
                  onTap: () => controller.toggleInterest(category),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMajorSelectSection({required List<MajorCategory> categories}) {
    return GetBuilder<SignupMajorInterestController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '전공',
              style: AppTextStyles.textMedium(textColor: AppColors.gray80),
            ),
            AppGap.v4,
            Wrap(
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s12,
              children: categories.map((category) {
                return SelectableTag(
                  label: category.label,
                  isSelected: controller.selectedMajor == category,
                  onTap: () => controller.selectMajor(category),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GetBuilder<SignupMajorInterestController>(
      builder: (controller) {
        final isEnabled = controller.canProceed &&
            !controller.flowController.isLoading.value;

        return Column(
          children: [
            CustomButton(
              text: '다음',
              variant: ButtonVariant.primary,
              enabled: isEnabled,
              onPressed: isEnabled
                  ? () async {
                final result = await controller.submit();
                if (!context.mounted) return;
                if (result) {
                  // clear()는 SignupCompleteScreen에서 로그인 이동 시 처리
                  context.goNamed('signupComplete');
                }
              }
                  : null,
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