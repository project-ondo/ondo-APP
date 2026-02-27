import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

@immutable
class HomeRecommendChatList extends StatelessWidget {
  final List<Map<String, dynamic>> _chats;

  HomeRecommendChatList({super.key})
      : _chats = [
    for (int i = 0; i < 5; i++) ...{{}, {}, {}, {}},
  ];

  int _getPageTotal() => (_chats.length / 3).ceil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "커피챗 추천",
            style: AppTextStyles.titleBold16(),
          ),
          AppGap.v16,
          Expanded(child: _chatList()),
        ],
      ),
    );
  }

  Widget _chatList() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, pageIndex) {
        return Row(
          spacing: AppSpacing.s16,
          children: List.generate(3, (itemIndex) {
            final int currentItemIndex = (pageIndex * 3) + itemIndex;

            return currentItemIndex < _chats.length
                ? Flexible(
              child: HomeProfileCard(
                skill: "UI/UX",
                name: "김유찬",
                rating: 4,
              ),
            )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: _getPageTotal(),
    );
  }
}