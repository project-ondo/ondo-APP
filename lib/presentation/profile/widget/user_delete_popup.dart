import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';

class UserDeletePopup {
  static Future<void> userDeletePopup(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: AppColors.white,
          insetPadding: AppPadding.screenHorizontal,
          child: Container(
            padding: AppPadding.actionPopup,
            decoration: BoxDecoration(
              borderRadius:AppRadius.popupRadius,
              color: AppColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("회원탈퇴", style: AppTextStyles.popupTitle())),
                AppGap.v24,
                Center(
                  child: Text(
                    '정말로 탈퇴하시겠습니까?',
                    style: AppTextStyles.textMedium(),
                  ),
                ),
                AppGap.v24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "회원탈퇴",
                        variant: ButtonVariant.outline,
                        hasBorder: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    AppGap.h12,
                    Expanded(
                      child: CustomButton(
                        text: "아니오",
                        variant: ButtonVariant.select,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
