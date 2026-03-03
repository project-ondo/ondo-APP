import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityFilterTagList extends GetView<CommunityController> {
  const CommunityFilterTagList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filterTags.length,
        separatorBuilder: (context, index) => AppGap.h16,
        itemBuilder: (context, index) => CustomTagCard(
          tag: controller.filterTags[index],
          onTap: controller.filterPosts,
        ),
      ),
    );
  }
}
