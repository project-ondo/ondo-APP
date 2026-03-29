import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

@immutable
abstract class BaseHomeProfileList extends StatelessWidget {
  const BaseHomeProfileList({super.key, required this.title});

  final String title;

  List<Widget> listBuilder ();

  int _getPageTotal() => (listBuilder().length / 3).ceil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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

              return currentItemIndex < listBuilder().length
                  ? Flexible(
                      child: listBuilder()[currentItemIndex]
                    )
                  : SizedBox.shrink();
            }),
          );
        },
        itemCount: _getPageTotal(),
      );
  }
}
