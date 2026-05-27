import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/post/widgets/post_list_indicator.dart';

class IndicatorPostPageList extends StatefulWidget {
  const IndicatorPostPageList({
    super.key,
    required this.title,
    required this.items,
    this.itemFloors = 2,
    this.scrollable = false,
    this.itemHeight = 127,
  });

  final double itemHeight;
  final String title;
  final List<Widget> items;
  final int itemFloors;
  final bool scrollable;

  @override
  State<IndicatorPostPageList> createState() => _IndicatorPostPageListState();
}

class _IndicatorPostPageListState extends State<IndicatorPostPageList> {
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final PageController _pageController = PageController();
  late var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final list = widget.items;
    final pagePerItemCount = widget.itemFloors * 2;
    final pageCount = (list.length / pagePerItemCount).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v16,
        //게시물 리스트 제목(ex 작성한 게시물 목록
        Padding(
          padding: AppPadding.screenHorizontal,
          child: Text(
            widget.title,
            style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
          ),
        ),
        AppGap.v16,
        //게시물 리스트
        SizedBox(
          height: widget.itemHeight * widget.itemFloors,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, int pageIndex) {
              final start = pageIndex * pagePerItemCount;
              final last = min((pageIndex + 1) * pagePerItemCount, list.length);
              final slice = list.sublist(start, last);
              return Padding(
                padding: AppPadding.screenHorizontal,
                child: GridView(
                  physics: widget.scrollable
                      ? null
                      : NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.s16,
                    crossAxisSpacing: AppSpacing.s16,
                    mainAxisExtent: widget.itemHeight,
                  ),
                  children: List.generate(
                    slice.length,
                    (itemIndex) => slice[itemIndex],
                  ),
                ),
              );
            },
          ),
        ),
        AppGap.v16,
        //게시물 인디케이터
        PostListIndicator(
          currentPage: _currentPage,
          totalPage: pageCount,
          onTap: (value) {
            _pageController.animateToPage(
              value,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
        AppGap.v16,
      ],
    );
  }
}
