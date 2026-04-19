import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_confirm_popup.dart';

class UserLogoutPopup {
  static Future<void> userLogoutPopup(
      BuildContext context, {
        required VoidCallback onLogout,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomConfirmPopup(
          title: '로그아웃',
          description: '정말 로그아웃 하시겠어요?',
          confirmText: '아니오',
          cancelText: '로그아웃',
          onConfirm: () => Navigator.pop(context),
          onCancel: () {
            Navigator.pop(context);
            onLogout();
          },
        );
      },
    );
  }
}