import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/chat/controllers/chat_main_controller.dart';
import 'package:ondo/presentation/search/widgets/main_top_search_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/widgets/chat_room_card.dart';

class ChatMainScreen extends GetView<ChatMainController> {
  const ChatMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: MainTopSearchBar(
        child: Container(
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
      () => ListView.separated(
        itemBuilder: (context, index) {
          final chatRoom = controller.viewChatRoomList[index];
          return ChatRoomCard(
            onTap: () {
              controller.enterChatRoom(index);
            },
            chatInfo: chatRoom,
          );
        },
        separatorBuilder: (context, index) => AppGap.v4,
        itemCount: controller.viewChatRoomList.length,
      ),
    );
  }
}
