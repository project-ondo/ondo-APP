import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';


@immutable
class HomeSearchPopup extends StatelessWidget {
  const HomeSearchPopup({super.key});

  final double _padding16 = AppSpacing.s16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 24,
        top: _padding16,
        left: _padding16,
        right: _padding16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TagSection(),

          AppGap.v16,

          _RecentSearchSection(),
        ],
      ),
    );
  }
}

@immutable
class _TagSection extends StatelessWidget {
  final List<String> tags;

  _TagSection() : tags = ["최근검색태그", "UI/UX", "Android", "멘토링", "팁", "공부인증"];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s12,
      children: List.generate(tags.length, (index) {
        final String tagName = tags[index];
        return _tagWidget(tagName);
      }),
    );
  }

  Widget _tagWidget(String tag) {
    return Container(
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: AppRadius.baseRadius,
      ),
      child: Text(
        tag,
        style: AppTextStyles.textMedium(),
      ),
    );
  }
}

@immutable
class _RecentSearchSection extends StatelessWidget {
  final List<String> searchTexts;

  _RecentSearchSection()
    : searchTexts = ["UIUX", "공부", "공부방법", "공부인증", "김유찬", "공부", "공부방법", "공부인증"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: List.generate(searchTexts.length, (index) {
        final String text = searchTexts[index];
        return _textWidget(text);
      }),
    );
  }

  Widget _textWidget(String text) {
    return Text(
      text,
      style: AppTextStyles.textMedium(textColor: AppColors.gray90),
    );
  }
}
