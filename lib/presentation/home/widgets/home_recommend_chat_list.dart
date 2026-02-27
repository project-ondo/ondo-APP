import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

@immutable
class HomeRecommendChatList extends GetView<HomeController> {
  const HomeRecommendChatList({super.key});

  int _getPageTotal() => (controller.chats.length / 3).ceil();

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
    return Obx(() {
      final chats = controller.chats;
      return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, pageIndex) {
          return Row(
            spacing: AppSpacing.s16,
            children: List.generate(3, (itemIndex) {
              final int currentItemIndex = (pageIndex * 3) + itemIndex;

              return currentItemIndex < chats.length
                  ? Flexible(
                      child: HomeProfileCard(
                        skill: chats[currentItemIndex].skill,
                        name: chats[currentItemIndex].name,
                        rating: chats[currentItemIndex].rating,
                      ),
                    )
                  : SizedBox.shrink();
            }),
          );
        },
        itemCount: _getPageTotal(),
      );
    });
  }
}
