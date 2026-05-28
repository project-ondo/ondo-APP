import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ReviewChips extends StatelessWidget {
  const ReviewChips({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> mockReviews = [
      "질문에 대한 답변이 빨라요",
      "친절해요",
      "매너가 좋아요",
      "상세하게 설명해줘요",
      "친절해요",
      "매너가 좋아요",
    ];
    final Map<String, int> countReviews = {};

    for (final review in mockReviews) {
      countReviews.update(
        review,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        spacing: AppSpacing.s12,
        runSpacing: AppSpacing.s12,
        children: countReviews.entries.map(
          (e) {
            final text = e.key;
            final count = e.value;

            return Container(
              padding: AppPadding.chip,
              decoration: BoxDecoration(
                color: AppColors.gray20,
                borderRadius: AppRadius.baseRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.textMedium(
                      textColor: AppColors.gray90,
                    ),
                  ),
                  if (count > 1) ...[
                    AppGap.h10,
                    Text(
                      "X$count",
                      style: AppTextStyles.textMedium(
                        textColor: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
