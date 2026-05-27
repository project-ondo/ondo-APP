import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_shadow.dart';

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
    this.subtitle,
    this.itemBuilder,
    this.backAction,
  });

  final bool moreOptions;
  final bool useUserProfile;
  final (Widget profile, String name)? userInfo;
  final String? subtitle;
  final PopupMenuItemBuilder<String>? itemBuilder;
  final VoidCallback? backAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.topBar,
      decoration: BoxDecoration(
        boxShadow: [
          AppShadow.barShadow,
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
                onTap: backAction ?? Get.back,
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userInfo!.$2,
            style: AppTextStyles.textMedium(textColor: AppColors.gray90),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.caption(textColor: AppColors.gray60),
            ),
        ],
      ),
    ],
  );
}
