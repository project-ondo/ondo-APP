import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

@immutable
abstract class BasePostList extends StatelessWidget {
  final String title;
  final double itemHeight;
  final bool scrollable;

  const BasePostList({
    super.key,
    required this.title,
    this.itemHeight = 143,
    this.scrollable = false,
  });

  List<Widget> list();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),

        AppGap.v16,

        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: ((list().length / 2).ceil() * itemHeight) - 16,
            maxWidth: double.maxFinite,
          ),
          child: _PostList(scrollable: scrollable, list: list()),
        ),
      ],
    );
  }

  Widget _title() {
    return Text(
      title,
      style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
    );
  }
}

@immutable
abstract class BasePostPageList extends StatelessWidget {
  final String title;
  final double itemHeight;
  final int floors;
  final bool scrollable;

  const BasePostPageList({
    super.key,
    required this.title,
    this.floors = 2,
    this.itemHeight = 143,
    this.scrollable = false,
  });

  List<Widget> list();

  int _pageItemCount() => floors * 2;

  bool _isTight() => list().length % _pageItemCount() == 0;

  int _pageTotal() => (list().length / _pageItemCount()).ceil();

  int _startIndex (int pageIndex) => pageIndex * _pageItemCount();

  int _lastIndex(int pageIndex) {
    return pageIndex == _pageTotal() - 1 && !_isTight()
        ? _startIndex(pageIndex) + list().length % _pageItemCount()
        : _startIndex(pageIndex) + _pageItemCount();
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(title: title),

        AppGap.v16,

        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (floors * itemHeight) - 16,
            maxWidth: double.maxFinite,
          ),
          child: PageView.builder(
            itemBuilder: (context, pageIndex) {
              final int startIndex = pageIndex * _pageItemCount();
              return _PostList(
                scrollable: scrollable,
                list: list().sublist(
                  startIndex,
                  _lastIndex(pageIndex),
                ),
              );
            },
            itemCount: _pageTotal(),
          ),
        ),
      ],
    );
  }
}

class _PostList extends StatelessWidget {
  final bool scrollable;
  final List<Widget> list;

  const _PostList({required this.scrollable, required this.list});

  final double _itemSpace = AppSpacing.s16;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: _itemSpace,
        crossAxisSpacing: _itemSpace,
        childAspectRatio: 1.4,
      ),
      children: List.generate(
        list.length,
        (index) => list[index],
      ),
    );
  }
}

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
