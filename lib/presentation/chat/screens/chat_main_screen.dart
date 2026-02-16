import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/core/design_system/components/top_bar/main_top_bar.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/chat/widgets/chat_card.dart';

void main () {
  runApp(MaterialApp(home: ChatMainScreen(),));
}

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: MainTopBar(
        child: Container(
          color: AppColors.background,
          padding: AppPadding.screenHorizontal,
          child: Column(
            children: [
              AppGap.v16,
              _Tags(),
              AppGap.v16,
              _ChatList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  final List<String> tags = [
    "최근검색태그",
    "UI/UX",
    "Android",
    "멘토링",
    "팁",
    "공부인증",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CustomTagCard(tag: tags[index]),
        itemCount: tags.length,
        separatorBuilder: (context, index) => AppGap.h16,
      ),
    );
  }
}

class _ChatList extends StatefulWidget {
  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  final List chatRooms = List.filled(10, 1);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 516),
      child: ListView.separated(
        itemBuilder: (context, index) =>
            ChatCard(
              bookmark: index % 2 == 0,
              name: "김유찬",
              lastChatAt: Duration(hours: 3),
              lastChat: "ㄹㅇ 다크패턴은 법으로 좀 쳐야 함... 탈퇴 버튼 숨겨 놓는 애들은 뭐냐?",
              newChatCount: index % 3,
            ),
        separatorBuilder: (context, index) => AppGap.v4,
        itemCount: chatRooms.length,
      ),
    );
  }
}
