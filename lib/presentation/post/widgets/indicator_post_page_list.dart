import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/components/app_empty_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/presentation/post/widgets/post_list_indicator.dart';

class IndicatorPostPageList extends StatefulWidget {
  const IndicatorPostPageList({
    super.key,
    required this.title,
    required this.items,
    this.itemFloors = 2,
    this.scrollable = false,
    this.itemHeight = 127,
    this.onLastPage,
    this.isLoading = false,
    this.emptyMessage = '게시물이 없어요.',
  });

  final double itemHeight;
  final String title;
  final List<Widget> items;
  final int itemFloors;
  final bool scrollable;
  final VoidCallback? onLastPage;
  final bool isLoading;
  final String emptyMessage;

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
    final listHeight = widget.itemHeight * widget.itemFloors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v16,
        Padding(
          padding: AppPadding.screenHorizontal,
          child: Text(
            widget.title,
            style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
          ),
        ),
        AppGap.v16,
        SizedBox(
          height: listHeight,
          child: _listContent(list, pageCount, pagePerItemCount),
        ),
        AppGap.v16,
        if (list.isNotEmpty)
          PostListIndicator(
            currentPage: _currentPage,
            totalPage: pageCount,
            onTap: (value) {
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          ),
        AppGap.v16,
      ],
    );
  }

  Widget _listContent(List<Widget> list, int pageCount, int pagePerItemCount) {
    if (widget.isLoading && list.isEmpty) {
      return const AppLoadingIndicator();
    }
    if (list.isEmpty) {
      return AppEmptyState(
        message: widget.emptyMessage,
        icon: AppIcon.communityUnSelect,
      );
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: pageCount,
      onPageChanged: (value) {
        setState(() => _currentPage = value);
        if (value == pageCount - 1) widget.onLastPage?.call();
      },
      itemBuilder: (context, int pageIndex) {
        final start = pageIndex * pagePerItemCount;
        final last = min((pageIndex + 1) * pagePerItemCount, list.length);
        final slice = list.sublist(start, last);
        return Padding(
          padding: AppPadding.screenHorizontal,
          child: GridView(
            physics: widget.scrollable
                ? null
                : const NeverScrollableScrollPhysics(),
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
    );
  }
}
