import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/components/custom_confirm_popup.dart';

class UserDeletePopup {
  static Future<void> userDeletePopup(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomConfirmPopup(
          title: "회원탈퇴",
          description: "정말로 탈퇴하시겠습니까?",
          confirmText: "회원탈퇴",
          cancelText: "아니오",
          onConfirm: () => log("회원탈퇴"),
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }
}
