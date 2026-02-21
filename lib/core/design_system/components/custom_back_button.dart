import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_colors.dart';
import '../app_icon.dart';
import '../app_layout.dart';
import '../app_text_styles.dart';
import 'custom_popup_menu_button.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {
    super.key,
    required this.moreOptions,
    this.itemBuilder,
  });

  final bool moreOptions;
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
          GestureDetector(
            onTap: () => log("프로필 이동"),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppIcon.arrowLeft.path),
                AppGap.v4,
                Text(
                  "이전으로",
                  style: AppTextStyles.textMedium(
                    textColor: AppColors.gray60,
                  ),
                ),
              ],
            ),
          ),
          if (moreOptions)
            CustomPopupMenuButton(itemBuilder: itemBuilder!)
          else
            SizedBox(),
        ],
      ),
    );
  }
}
