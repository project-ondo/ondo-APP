import 'package:flutter/material.dart';
import 'package:ondo/presentation/post/widgets/indicator_post_page_list.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';

class ProfileIndicatorPostPageList extends StatelessWidget {
  const ProfileIndicatorPostPageList({
    super.key,
    required this.title,
    required this.postItemCount,
    required this.postItemList,
    this.emptyMessage = '게시물이 없어요.',
  });

  final String title;
  final int postItemCount;
  final List<PostItem> postItemList;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return IndicatorPostPageList(
      title: title,
      itemFloors: 2,
      items: postItemList,
      emptyMessage: emptyMessage,
    );
  }
}
