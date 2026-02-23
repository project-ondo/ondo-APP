import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/presentation/profile/widget/activity_state_card.dart';

class ProfileActivitySection extends StatelessWidget {
  const ProfileActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ActivityStateCard(name: "작성한 게시물", currentState: "24")),
        AppGap.h8,
        Expanded(child: ActivityStateCard(name: "커피챗 횟수", currentState: "24")),
        AppGap.h8,
        Expanded(child: ActivityStateCard(name: "받은 리뷰 수", currentState: "24")),
      ],
    );
  }
}
