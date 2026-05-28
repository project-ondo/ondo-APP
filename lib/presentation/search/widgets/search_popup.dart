import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/search/controllers/search_popup_controller.dart';

@immutable
class SearchPopup extends StatelessWidget {
  const SearchPopup({super.key, required this.pageId});

  final String pageId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        padding: AppPadding.popup,
        decoration: BoxDecoration(color: AppColors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Tags(
              pageId: pageId,
            ),
            AppGap.v16,
            _Tips(pageId: pageId),
          ],
        ),
      ),
    );
  }
}

@immutable
class _Tags extends GetView<SearchPopupController> {
  final String pageId;

  const _Tags({required this.pageId});

  @override
  String? get tag => pageId;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final tags = controller.viewSearchTagList;

        return Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s12,
          children: tags
              .map(
                (tag) => CustomTagCard(
                  onTap: (isSelect) => controller.selectSearchTag(tag),
                  tag: tag,
                  color: AppColors.gray20,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

@immutable
class _Tips extends GetView<SearchPopupController> {
  final String pageId;

  const _Tips({required this.pageId});

  @override
  String? get tag => pageId;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final tips = controller.viewSearchTipList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s16,
          children: tips
              .map(
                (tip) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.selectSearchTip(tip),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        tip,
                        style: AppTextStyles.textMedium(
                          textColor: AppColors.gray90,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
