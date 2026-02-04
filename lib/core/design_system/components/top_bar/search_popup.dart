import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/main_top_bar_search_controller.dart';

@immutable
class SearchPopup extends StatelessWidget {
  final SearchPopupController _controller = Get.find<SearchPopupController>();

  SearchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: AppPadding.popUp,
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _Tags(tags: _controller.showTags.value,),),
          AppGap.v16,
          Obx(() => _RecentSearchSection(tips: _controller.showSearchTips.value),),
        ],
      ),
    );
  }
}

@immutable
class _Tags extends StatelessWidget {
  final List<String> tags;

  const _Tags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s12,
      children: List.generate(tags.length, (index) => _tagWidget(tags[index])),
    );
  }

  Widget _tagWidget(String tag) {
    return Container(
      padding: AppPadding.chip,
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: AppRadius.baseRadius,
      ),
      child: Text(tag, style: AppTextStyles.textMedium(),),
    );
  }
}

@immutable
class _RecentSearchSection extends StatelessWidget {
  final List<String> tips;

  const _RecentSearchSection({required this.tips});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: List.generate(tips.length, (index) => _textWidget(tips[index])),
    );
  }

  Widget _textWidget(String text) {
    return SizedBox(
      width: double.maxFinite,
      child: Text(text, style: AppTextStyles.textMedium(textColor: AppColors.gray90)),
    );
  }
}
