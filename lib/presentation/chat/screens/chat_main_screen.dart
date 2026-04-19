import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/chat/controllers/main_chat_controller.dart';
import 'package:ondo/presentation/search/widgets/main_top_search_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/widgets/chat_room_card.dart';

class ChatMainScreen extends GetView<MainChatController> {
  const ChatMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: MainTopSearchBar(
        pageId: "chat",
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
        resultPageBuilder: (state) {
          if (state.query.isEmpty || state.tags.isEmpty) return;
          controller.search(state.query, state.tags.toList());
          return null;
        },
      ),
    );
  }
}

class TagList extends GetView<MainChatController> {
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

class ChatList extends GetView<MainChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        itemBuilder: (context, index) {
          final chatRoom = controller.viewChatRoomList[index];
          return ChatRoomCard(
            onTap: () {
              //TODO : chat model 정의 후 관련 데이터 전달
              controller.enterChatRoom();
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
