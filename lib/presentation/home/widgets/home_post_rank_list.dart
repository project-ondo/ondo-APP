import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/components/app_empty_state.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/home_post_rank_item.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

@immutable
class HomePostRankList extends StatefulWidget {
  const HomePostRankList({super.key});

  @override
  State<HomePostRankList> createState() => _HomePostRankListState();
}

class _HomePostRankListState extends State<HomePostRankList> {
  late final PageController _pageController;
  late final HomeController _mainController;
  late final PostController _postController;

  ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  void initState() {
    _mainController = Get.find<HomeController>();
    _postController = Get.find<PostController>();
    _pageController = PageController(
      initialPage: curIndex.value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.maxFinite,
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPadding.screenHorizontal,
            child: Text(
              "실시간 인기 게시물",
              style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
            ),
          ),
          AppGap.v16,
          Expanded(child: _postList()),
          _indicator(),
        ],
      ),
    );
  }

  Widget _postList() {
    return Obx(() {
      if (_mainController.isLoadingRanks.value) {
        return const AppLoadingIndicator();
      }
      if (_mainController.rankErrorMessage.value.isNotEmpty) {
        return AppErrorState(
          message: _mainController.rankErrorMessage.value,
          onRetry: () => _mainController.retryLoadRanks(),
        );
      }

      final ranks = _mainController.recentPopularPostList;
      if (ranks.isEmpty) {
        return const AppEmptyState(
          message: '현재 집계된 인기 게시물이 없어요.',
          icon: AppIcon.homeUnSelect,
        );
      }

      final pageCount = (ranks.length / 3).ceil();
      return PageView.builder(
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: (value) {
          curIndex.value = value;
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, pageIndex) {
          return Column(
            spacing: AppSpacing.s16,
            children: List.generate(3, (itemIndex) {
              final currentItemIndex = (pageIndex * 3) + itemIndex;

              return currentItemIndex < ranks.length
                  ? Padding(
                      padding: AppPadding.screenHorizontal,
                      child: HomePostRankItem(
                        post: ranks[currentItemIndex],
                        onTap: () {
                          //TODO : 나의 게시물인지 판단하여 넘김
                          _postController.enterPostDetail(
                            context,
                            false,
                            ranks[currentItemIndex].postId,
                          );
                        },
                        heartAction: (isFavorite, total) {
                          _mainController.toggleLike(
                            ranks[currentItemIndex].postId,
                            isFavorite,
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink();
            }),
          );
        },
        itemCount: pageCount,
      );
    });
  }

  Widget _indicator() {
    return Obx(() {
      final pageCount =
          (_mainController.recentPopularPostList.length / 3).ceil();
      if (pageCount <= 1) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ValueListenableBuilder(
          valueListenable: curIndex,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.s6,
              children: List.generate(
                pageCount,
                (index) => _indicatorIcon(index == value % pageCount),
              ),
            );
          },
        ),
      );
    });
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
