import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/widgets/post_comment_card.dart';
import 'package:ondo/presentation/post/widgets/post_comment_create_field.dart';
import 'post_list_indicator.dart';

class PostCommentList extends StatefulWidget {
  const PostCommentList({super.key});

  @override
  State<PostCommentList> createState() => _PostCommentListState();
}

class _PostCommentListState extends State<PostCommentList> {
  late final PageController _pageController;
  final PostViewController controller = Get.find<PostViewController>();

  final ValueNotifier<int> curIndex = ValueNotifier(0);

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Obx(
        () {
          final list = controller.comments;
          final pageCount = (list.length / 4).ceil();

          return Column(
            children: [
              _title(),
              AppGap.v16,
              PostCommentCreateField(
                controller: controller.commentController,
                authorName: "김유찬", //TODO : 앱 사용자 정보를 가지는 Store가 정의되면 불러오기
                profileUrl: null,
                submit: (m) {
                  controller.createComment(m);
                },
              ),
              AppGap.v16,
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    curIndex.value = value;
                  },
                  itemCount: pageCount,
                  itemBuilder: (context, pIndex) => Column(
                    spacing: AppSpacing.s16,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      4,
                      (iIndex) {
                        final itemIndex = (pIndex * 4) + iIndex;
                        if (itemIndex >= controller.comments.length) {
                          return Spacer();
                        }
                        final comment = controller.comments[itemIndex];
                        return Expanded(
                          child: PostCommentCard(
                            comment: comment,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              AppGap.v16,
              ValueListenableBuilder(
                valueListenable: curIndex,
                builder: (context, value, _) => PostListIndicator(
                  currentPage: value,
                  totalPage: pageCount,
                  onTap: (value) {
                    _pageController.animateToPage(
                      value,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
              AppGap.v16,
            ],
          );
        },
      ),
    );
  }

  Widget _title() => Row(
    children: [
      Text("댓글", style: AppTextStyles.titleSm16(textColor: AppColors.gray90)),
      AppGap.h12,
      Text(
        "${controller.comments.length}",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
    ],
  );
}
