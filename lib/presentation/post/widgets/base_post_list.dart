import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

@immutable
abstract class BasePostGrid extends StatelessWidget {
  final String title;
  final bool scrollable;

  const BasePostGrid({
    super.key,
    required this.title,
    this.scrollable = false,
  });

  List<Widget> listBuilder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
        ),
        AppGap.v16,
        _PostGrid(scrollable: scrollable, list: listBuilder()),
      ],
    );
  }
}

@immutable
abstract class BasePostPageList extends StatelessWidget {
  final String title;
  final double? pageHeight;
  final int floors;
  final bool scrollable;

  const BasePostPageList({
    super.key,
    required this.title,
    this.floors = 2,
    this.pageHeight,
    this.scrollable = false,
  });

  List<Widget> list();

  int _pageItemCount() => floors * 2;

  bool _isTight() => list().length % _pageItemCount() == 0;

  int _pageTotal() => (list().length / _pageItemCount()).ceil();

  int _startIndex(int pageIndex) => pageIndex * _pageItemCount();

  int _lastIndex(int pageIndex) {
    return pageIndex == _pageTotal() - 1 && !_isTight()
        ? _startIndex(pageIndex) + list().length % _pageItemCount()
        : _startIndex(pageIndex) + _pageItemCount();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: pageHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(title: title),
          AppGap.v16,
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, pageIndex) {
                final int startIndex = pageIndex * _pageItemCount();
                return _PostGrid(
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
      ),
    );
  }
}

class _PostGrid extends StatelessWidget {
  final bool scrollable;
  final List<Widget> list;

  const _PostGrid({required this.scrollable, required this.list});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.s16,
        crossAxisSpacing: AppSpacing.s16,
        childAspectRatio: 3 / 2,
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
