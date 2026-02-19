import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class PostListIndicator extends StatelessWidget {
  const PostListIndicator({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.onTap,
  });

  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final int currentIndicatorIndex = currentPage + 1;
    final List<Widget> indicatorSetup = [];

    void addPage(int page) {
      final bool isCurrent = page == currentIndicatorIndex;

      indicatorSetup.add(
        GestureDetector(
          onTap: () => onTap(page - 1),
          child: Padding(
            padding: AppPadding.indicatorSpacing,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$page",
                  style: AppTextStyles.textMedium(
                    textColor: isCurrent ? AppColors.primary : AppColors.gray40,
                  ),
                ),
                if (isCurrent)
                Container(
                  margin: AppPadding.currentIndicatorUnderline,
                  height: AppSpacing.s1,
                  width: AppSpacing.s9,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    void addEllipsis() {
      indicatorSetup.add(
        Padding(
          padding: AppPadding.indicatorSpacing,
          child: Row(
            spacing: AppSpacing.s6,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppSpacing.s4,
                height: AppSpacing.s4,
                decoration: ShapeDecoration(
                  color: AppColors.gray40,
                  shape: OvalBorder(),
                ),
              ),
              Container(
                width: AppSpacing.s4,
                height: AppSpacing.s4,
                decoration: ShapeDecoration(
                  color: AppColors.gray40,
                  shape: OvalBorder(),
                ),
              ),
              Container(
                width: AppSpacing.s4,
                height: AppSpacing.s4,
                decoration: ShapeDecoration(
                  color: AppColors.gray40,
                  shape: OvalBorder(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    addPage(1);

    if (currentIndicatorIndex > 3) addEllipsis();

    for (
      int i = currentIndicatorIndex - 1;
      i <= currentIndicatorIndex + 1;
      i++
    ) {
      if (i > 1 && i < totalPage) addPage(i);
    }

    if (currentIndicatorIndex < totalPage - 2) addEllipsis();

    if (totalPage > 1) addPage(totalPage);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicatorSetup,
    );
  }
}
