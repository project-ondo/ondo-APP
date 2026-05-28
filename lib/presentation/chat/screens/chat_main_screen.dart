import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/chat/controllers/chat_main_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/widgets/chat_room_card.dart';

class ChatMainScreen extends GetView<ChatMainController> {
  const ChatMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        color: AppColors.background,
        padding: AppPadding.screenHorizontal,
        child: Column(
          children: [
            AppGap.v16,
            TagList(),
            AppGap.v16,
            Expanded(child: ChatList()),
            AppGap.v16,
          ],
        ),
      ),
    );
  }
}

class TagList extends GetView<ChatMainController> {
  const TagList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CustomTagCard(
          tag: controller.tags[index],
          onTap: (isSelect) =>
              controller.selectTag(controller.tags[index], isSelect),
        ),
        itemCount: controller.tags.length,
        separatorBuilder: (context, index) => AppGap.h16,
      ),
    );
  }
}

class ChatList extends GetView<ChatMainController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final list = controller.viewChatRoomList;
        final isLoadingMore = controller.isLoadingMore.value;
        return ListView.separated(
          controller: controller.scrollController,
          itemCount: list.length + (isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => AppGap.v4,
          itemBuilder: (context, index) {
            if (index == list.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return ChatRoomCard(
              onTap: () => controller.enterChatRoom(index),
              chatInfo: list[index],
            );
          },
        );
      },
    );
  }
}
