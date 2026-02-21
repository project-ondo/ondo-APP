import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ChatReviewDialog extends StatelessWidget {
  const ChatReviewDialog({super.key});

  void _tapStar(int index) {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text(
            "리뷰 남기기",
            style: AppTextStyles.popupTitle(),
          ),
        ],
      ),
    );
  }

  Widget _stars() => Row(
    children: List.generate(
      5,
      (index) => _starIcon(index),
    ),
  );

  Widget _starIcon(int index) => GestureDetector(
    onTap: () {
      _tapStar(index);
    },
    child: Image.asset(
      AppIcon.star.path,
      width: 28,
      height: 28,
    ),
  );
}
