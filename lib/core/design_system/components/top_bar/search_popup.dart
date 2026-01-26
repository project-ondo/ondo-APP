import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/top_bar_search_controller.dart';

@immutable
class SearchPopup extends StatelessWidget {
  final SearchPopupController _controller = Get.find<SearchPopupController>();

  SearchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final tags = _controller.showTags.value;
          return _Tags(
            tags: tags,
          );
        }),

        AppGap.v16,

        Obx(() {
          final tips = _controller.showSearchTips.value;
          return _RecentSearchSection(
            tips: tips,
          );
        }),
      ],
    );
  }
}

@immutable
class _Tags extends StatelessWidget {
  final List<String> tags;

  const _Tags({required this.tags});

  final double _hSpacing = AppSpacing.s16;
  final double _vSpacing = AppSpacing.s12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        spacing: _hSpacing,
        runSpacing: _vSpacing,
        children: List.generate(tags.length, (index) {
          final String tagName = tags[index];
          return _tagWidget(tagName);
        }),
      ),
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
  final List<String> tips;

  const _RecentSearchSection({required this.tips});

  final double _vSpacing = AppSpacing.s16;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _vSpacing,
      children: List.generate(tips.length, (index) {
        final String text = tips[index];
        return _textWidget(text);
      }),
    );
  }

  Widget _textWidget(String text) {
    return SizedBox(
      width: double.maxFinite,
      child: Text(
        text,
        style: AppTextStyles.textMedium(textColor: AppColors.gray90),
      ),
    );
  }
}
