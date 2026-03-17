import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../app_icon.dart';
import '../app_layout.dart';
import '../app_text_styles.dart';
import 'custom_popup_menu_button.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    required this.moreOptions,
    this.useUserProfile = false,
    this.userInfo,
    this.itemBuilder,
  });

  final bool moreOptions;
  final bool useUserProfile;
  final (Widget profile, String name)? userInfo;
  final PopupMenuItemBuilder<String>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.topBar,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x05781F07),
            blurRadius: AppSpacing.s16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: Get.back,
                child: SvgPicture.asset(AppIcon.arrowLeft.path),
              ),
              if (!useUserProfile) _text() else _profile(),
            ],
          ),
          if (moreOptions)
            CustomPopupMenuButton(itemBuilder: itemBuilder!)
          else
            SizedBox(),
        ],
      ),
    );
  }

  Widget _text() => GestureDetector(
    onTap: Get.back,
    child: Row(
      children: [
        AppGap.v4,
        Text(
          "이전으로",
          style: AppTextStyles.textMedium(
            textColor: AppColors.gray60,
          ),
        ),
      ],
    ),
  );

  Widget _profile() => Row(
    children: [
      AppGap.h12,
      SizedBox.square(
        dimension: 24,
        child: userInfo!.$1,
      ),
      AppGap.h12,
      Text(
        userInfo!.$2,
        style: AppTextStyles.textMedium(textColor: AppColors.gray90),
      ),
    ],
  );
}
