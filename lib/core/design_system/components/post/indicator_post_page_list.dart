import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/post/post_list_indicator.dart';

class IndicatorPostPageList extends StatefulWidget {
  const IndicatorPostPageList({
    super.key,
    required this.title,
    required this.items,
    this.itemFloors = 2,
    this.scrollable = false,
  });

  final String title;
  final List<Widget> items;
  final int itemFloors;
  final bool scrollable;
  final double itemsHeight = 127;

  @override
  State<IndicatorPostPageList> createState() => _IndicatorPostPageListState();
}

class _IndicatorPostPageListState extends State<IndicatorPostPageList> {

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final PageController _controller = PageController();
  late var _currentPage = 0;

  List<Widget> list() => widget.items;

  int _pageItemCount() => widget.itemFloors * 2;

  int _pageTotal() => (list().length / _pageItemCount()).ceil();

  int _startIndex(int pageIndex) => pageIndex * _pageItemCount();

  int _endIndex(int pageIndex) =>
      min(_startIndex(pageIndex) + _pageItemCount(), list().length);

  double get _pageHeight {
    final rows = widget.itemFloors;
    const spacing = AppSpacing.s16;

    return rows * widget.itemsHeight + (rows - 1) * spacing;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //게시물 리스트 제목(ex 작성한 게시물 목록
        Text(
          widget.title,
          style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
        ),
        AppGap.v16,
        //게시물 리스트
        SizedBox(
          height: _pageHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: _pageTotal(),
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, int pageIndex) {
              final slice = list().sublist(
                _startIndex(pageIndex),
                _endIndex(pageIndex),
              );

              return GridView(
                physics: widget.scrollable
                    ? null
                    : NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.s16,
                  crossAxisSpacing: AppSpacing.s16,
                  childAspectRatio: 1.37,
                ),
                children: List.generate(
                  slice.length,
                      (index) => slice[index],
                ),
              );
            },
          ),
        ),
        AppGap.v16,
        //게시물 인디케이터
        PostListIndicator(
          currentPage: _currentPage,
          totalPage: _pageTotal(),
          onTap: (value) {
            _controller.animateToPage(
              value,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ],
    );
  }
}