import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';

@immutable
class SearchPopup extends StatelessWidget {
  const SearchPopup({super.key});

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
            _Tags(),
            AppGap.v16,
            _Tips(),
          ],
        ),
      ),
    );
  }
}

@immutable
class _Tags extends GetView<MainTopBarSearchController> {
  final SearchPopupController popupController =
      Get.find<SearchPopupController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: AppSpacing.s16,
        runSpacing: AppSpacing.s12,
        children: List.generate(
          popupController.viewTags.length,
          (index) => CustomTagCard(
            onTap: (isSelect) =>
                controller.selectTag(popupController.viewTags[index], isSelect),
            tag: popupController.viewTags[index],
            color: AppColors.gray20,
          ),
        ),
      ),
    );
  }
}

@immutable
class _Tips extends GetView<MainTopBarSearchController> {
  final SearchPopupController popupController =
      Get.find<SearchPopupController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s16,
        children: List.generate(
          popupController.viewTips.length,
          (index) => _tipTile(context, popupController.viewTips[index]),
        ),
      ),
    );
  }

  Widget _tipTile(BuildContext context, String tip) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.onSubmit(context, keyword: tip),
        child: SizedBox(
          width: double.maxFinite,
          child: Text(
            tip,
            style: AppTextStyles.textMedium(textColor: AppColors.gray90),
          ),
        ),
      ),
    );
  }
}
