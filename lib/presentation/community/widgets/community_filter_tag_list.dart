import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityFilterTagList extends GetView<CommunityController> {
  const CommunityFilterTagList({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = controller.viewTagList.indexed.toList();

    return SizedBox(
      height: AppSpacing.s36,
      child: ListView.separated(
        padding: AppPadding.screenHorizontal,
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (context, index) => AppGap.h16,
        itemBuilder: (context, index) {
          return CustomTagCard(
            onTap: (isSelect) => controller.filterPostTag(
              tags[index].$2,
              isSelect,
            ),
            label: tags[index].$2,
          );
        },
      ),
    );
  }
}
