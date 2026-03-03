import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/chat/controllers/chat_main_screen_controller.dart';
import 'package:ondo/presentation/search/widgets/main_top_search_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/widgets/chat_room_card.dart';

//TODO : Binding ChatMainScreenController 필수
class ChatMainScreen extends GetView<ChatMainScreenController> {
  const ChatMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: MainTopSearchBar(
        mainPage: Container(
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
        resultPageBuilder: (searchText) {
          controller.searchChatRooms(searchText);
          return null;
        },
      ),
    );
  }
}

class TagList extends GetView<ChatMainScreenController> {
  const TagList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s36,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              CustomTagCard(tag: controller.tags[index]),
          itemCount: controller.tags.length,
          separatorBuilder: (context, index) => AppGap.h16,
        ),
      ),
    );
  }
}

class ChatList extends GetView<ChatMainScreenController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        itemBuilder: (context, index) {
          final chatRoom = controller.viewChatRooms[index];
          return ChatRoomCard(
            bookmark: chatRoom.isBookmark,
            name: chatRoom.name,
            lastChatAt: chatRoom.lastChatAt,
            lastChat: chatRoom.lastChat,
            newChatCount: chatRoom.newChatCount,
          );
        },
        separatorBuilder: (context, index) => AppGap.v4,
        itemCount: controller.viewChatRooms.length,
      ),
    );
  }
}
