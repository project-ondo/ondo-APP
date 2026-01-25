import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/post_item.dart';

@immutable
abstract class BasePostList extends StatelessWidget {
  final String title;

  const BasePostList({super.key, required this.title});

  List<Widget> list();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(title: title),

        AppGap.v16,

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 270,
            maxWidth: 380,
          ),
          child: _PostList(list: list()),
        ),
      ],
    );
  }
}

@immutable
class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
    );
  }
}

class _PostList extends StatelessWidget {
  final List<Widget> list;

  const _PostList({required this.list});

  final double _itemSpace = 16;

  @override
  Widget build(BuildContext context) {
    return GridView(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: _itemSpace,
        crossAxisSpacing: _itemSpace,
        childAspectRatio: 0.7,
      ),
      children: List.generate(4, (index) {
        return index > list.length
            ? SizedBox.shrink()
            : PostItem(
                skills: ['UI/UX', 'FrontEnd'],
                title: "요즘 UI UX",
                author: "김유찬",
                bookmarks: 12,
                favorites: 12,
                createMinutes: 4,
              );
      }),
    );
  }
}
