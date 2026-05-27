import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/controllers/base_home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

class HomeProfileList extends StatelessWidget {
  const HomeProfileList({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final BaseHomeController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPadding.screenHorizontal,
            child: Text(
              title,
              style: AppTextStyles.titleBold16(),
            ),
          ),
          AppGap.v16,
          Expanded(child: _profileList()),
        ],
      ),
    );
  }

  Widget _profileList() {
    return Obx(
      () => ListView.separated(
        padding: AppPadding.screenHorizontal,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => AppGap.h16,
        itemBuilder: (context, index) {
          final chat = controller.viewUserList[index];

          return HomeProfileCard(
            publicId: chat.publicId,
            skill: chat.interests.first,
            name: chat.displayName,
            rating: chat.ratingCount,
          );
        },
        itemCount: controller.viewUserList.length,
      ),
    );
  }
}
