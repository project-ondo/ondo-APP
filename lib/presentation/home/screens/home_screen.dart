import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/home/widgets/home_popular_post_item.dart';
import 'package:ondo/presentation/home/widgets/home_top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          children: [
            HomeTopBar(),

            AppGap.v16,

            HomePopularPostList(),
          ],
        ),
      ),
    );
  }
}

@immutable
class HomePopularPostList extends StatelessWidget {
  final List<Map<String, dynamic>> popularPosts;

  HomePopularPostList({super.key}) : popularPosts = [{}, {}, {}, {}, {}];


  final double _indicatorSize = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "실시간 인기 게시물",
          style: AppTextStyles.titleBold16(textColor: AppColors.gray90),
        ),

        AppGap.v16,
    
        SizedBox(
          height: 186,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, pageIndex) {
              return Column(
                children: List.generate(3, (itemIndex) {
                  final currentItemIndex = (pageIndex * 3) + itemIndex;
                  if (currentItemIndex >= popularPosts.length) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                    child: HomePopularPostItem(
                      title: "요즘 공부 어케 하시나요 다들",
                      createAgo: 3,
                      favorite: 160,
                      rank: currentItemIndex + 1,
                    ),
                  );
                }),
              );
            },
            itemCount: (popularPosts.length ~/ 3) + 1,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circle(true),
            circle(false),
            circle(false),
          ],
        ),


      ],
    );
  }

  Widget circle(bool isFocus) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        width: _indicatorSize,
        height: _indicatorSize,
        decoration: BoxDecoration(
          color: isFocus ? AppColors.gray80 : AppColors.gray60,
          borderRadius: AppRadius.circleRadius,
        ),
      ),
    );
  }
}
