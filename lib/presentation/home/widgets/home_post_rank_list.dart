import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
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
          AppGap.v16,
          _indicator(),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _postList() {
    return Obx(() {
      final ranks = _mainController.ranks;
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
                        onTap: () {
                          //TODO : 나의 게시물인지 판단하여 넘김
                          _postController.enterPostDetail(
                            context,
                            false,
                            ranks[currentItemIndex].postId,
                          );
                        },
                        title: ranks[currentItemIndex].title,
                        createAgo: ranks[currentItemIndex].creatAt.inDays,
                        favorite: ranks[currentItemIndex].favorites,
                        rank: currentItemIndex + 1,
                        heartAction: (isFavorite, total) {
                          //TODO : model 정의되면 setter 적용
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
