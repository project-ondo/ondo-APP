import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_item.dart';

@immutable
class HomePostRankList extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  HomePostRankList({super.key})
      : posts = [
    for (int i = 0; i < 5; i++) ...{{}, {}, {}, {}},
  ];

  @override
  State<HomePostRankList> createState() => _HomePostRankListState();
}

class _HomePostRankListState extends State<HomePostRankList> {
  late final PageController _pageController;

  ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  void initState() {
    _pageController = PageController(initialPage: curIndex.value);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getPageTotal() => (widget.posts.length / 3).ceil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "실시간 인기 게시물",
            style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
          ),
          AppGap.v16,
          Expanded(child: _postList()),
          AppGap.v16,
          _indicator(),
        ],
      ),
    );
  }

  Widget _postList() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (value) {
        curIndex.value = value;
      },
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, pageIndex) {
        return Column(
          spacing: AppSpacing.s16,
          children: List.generate(3, (itemIndex) {
            final currentItemIndex = (pageIndex * 3) + itemIndex;

            return currentItemIndex < widget.posts.length
                ? HomePostRankItem(
              title: "요즘 공부 어케 하시나요 다들",
              createAgo: 3,
              favorite: 160,
              rank: currentItemIndex + 1,
            )
                : SizedBox.shrink();
          }),
        );
      },
      itemCount: _getPageTotal(),
    );
  }

  Widget _indicator() {
    return ValueListenableBuilder(
      valueListenable: curIndex,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.s6,
          children: List.generate(
            3,
                (index) => _indicatorIcon(index == value % 3),
          ),
        );
      },
    );
  }

  Widget _indicatorIcon(bool isFocus) {
    return Container(
      width: AppSpacing.s4,
      height: AppSpacing.s4,
      decoration: BoxDecoration(
        color: isFocus ? AppColors.gray80 : AppColors.gray60,
        borderRadius: AppRadius.circleRadius,
      ),
    );
  }
}