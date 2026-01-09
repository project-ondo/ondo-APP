import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

//실시간 인기 게시물 리스트
@immutable
class HomeRecentPopularList extends StatelessWidget {
  HomeRecentPopularList({super.key});

  //domain 쪽에서 세칸 씩 나눈 리스트로 넘김
  final List<List<PopularPostInfo>> postList = [
    [
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
    ],
    [
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
    ],
    [
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
    ],
    [
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
      PopularPostInfo(title: "요즘 공부 어케 하시나요 다들", popularity: 160, postAt: 3),
    ],
  ];

  //페이지 위치 표시
  final ValueNotifier currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //리스트 타이틀
          Text(
            "실시간 인기 게시물",
            style: AppTextStyles.titleBold16(),
          ),

          //게시물 리스트
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 143,
              child: PageView.builder(
                onPageChanged: (index) {
                  currentIndex.value = index;
                },
                itemBuilder: (context, pageIndex) {
                  //게시물 탭 리스트 페이지
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(postList[pageIndex].length, (
                      itemIndex,
                    ) {
                      final item = postList[pageIndex][itemIndex];
                      //게시물 탭
                      return RecentPopularPost(
                        rank: itemIndex,
                        title: item.title,
                        postDate: item.postAt,
                        popularity: item.popularity,
                      );
                    }),
                  );
                },
                itemCount: postList.length,
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: (index + 1) == (value % 3) + 1
                            ? AppColors.gray80
                            : AppColors.gray60,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  //게시물 표시 탭
}

//게시물 표시 탭
class RecentPopularPost extends StatelessWidget {
  final int rank;
  final String title;
  final int postDate;
  final int popularity;

  const RecentPopularPost({
    super.key,
    required this.rank,
    required this.title,
    required this.postDate,
    required this.popularity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          //랭크 인덱스 박스
          Container(
            width: 37,
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: AppTextStyles.textMedium(textColor: AppColors.primaryDark),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //제목
                Text(
                  title,
                  style: AppTextStyles.textMedium(),
                ),

                //게시물 날짜
                Text(
                  "$postDate일 전",
                  style: TextStyle(
                    color: AppColors.gray60,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              //종아요 표시
              Icon(
                Icons.heart_broken,
                size: 16,
                color: AppColors.gray60,
              ),

              //좋아요 수 표시
              Text(
                "$popularity",
                style: AppTextStyles.caption(textColor: AppColors.gray60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//인기 게시물 정보 모델
class PopularPostInfo {
  String title;
  int postAt;
  int popularity;

  PopularPostInfo({
    required this.title,
    required this.popularity,
    required this.postAt,
  });
}
