import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/report_type.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_report_dialog.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';
import 'package:ondo/presentation/profile/controllers/other_profile_controller.dart';
import 'package:ondo/presentation/profile/widget/profile_activity_section.dart';
import 'package:ondo/presentation/profile/widget/profile_indicator_post_page_list.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_section.dart';
import 'package:ondo/presentation/profile/widget/profile_rating_session.dart';
import 'package:ondo/presentation/profile/widget/user_introduction_text.dart';
import 'package:ondo/presentation/profile/widget/user_name_and_major.dart';
import 'package:ondo/presentation/profile/widget/user_profile_image.dart';
import 'package:ondo/data/models/user/response/user_profile_response_model.dart';

// TODO: 게시글 API 연동 후 교체
final List<Map<String, dynamic>> mockPostData = [
  {
    "skills": ["Flutter", "Firebase"],
    "title": "실전 Flutter 상태관리",
    "author": "허은서",
    "bookmarks": 12,
    "favorites": 5,
    "createMinutes": 3,
  },
  {
    "skills": ["UI/UX", "Figma"],
    "title": "모바일 UX 설계 방법",
    "author": "김민준",
    "bookmarks": 45,
    "favorites": 20,
    "createMinutes": 15,
  },
];
//TODO mock data 제거
final List<PostItem> _testPostItemList = mockPostData.map((data) {
  return PostItem(
    post: PostEntity(
      postId: data['postId'] ?? 0,
      title: data['title'],
      authorName: data['author'],
      tags: List<String>.from(data['skills']),
      viewCount: 10,
      likeCount: data['favorites'],
      commentCount: 10,
      bookmarkCount: data['bookmarks'],
      createAt: DateTime.now().subtract(
        Duration(minutes: data['createMinutes']),
      ),
    ),
    isMy: false,
  );
}).toList();

class OtherProfileScreen extends GetView<OtherProfileController> {
  const OtherProfileScreen({super.key, required this.publicId});

  final String publicId;

  @override
  Widget build(BuildContext context) {
    // 화면 진입 시 프로필 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProfile(publicId);
    });

    return SafeArea(
      child: BaseScaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (controller.isLoading.value && controller.profile.value == null) {
            return const AppLoadingIndicator();
          }

          if (controller.profileLoadFailed.value) {
            return AppErrorState(
              message: '프로필을 불러오지 못했어요.',
              onRetry: () => controller.loadProfile(publicId),
            );
          }

          final profile = controller.profile.value;

          return Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.depth == 0 &&
                      notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 200) {
                    controller.loadMoreRatings();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomBackButton(
                        moreOptions: true,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => CustomReportDialog(
                                type: ReportType.user,
                                targetId: publicId,
                              ),
                            ),
                            padding: AppPadding.settingSession,
                            child: Text(
                              '신고하기',
                              style: AppTextStyles.caption(
                                textColor: AppColors.gray90,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () => log('차단하기'), // TODO: 차단 API 연동
                            padding: AppPadding.settingSession,
                            child: Text(
                              '차단하기',
                              style: AppTextStyles.caption(
                                textColor: AppColors.gray90,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildOtherUserIntroductionSession(profile),
                      ProfileRatingSession(),
                      ProfileIndicatorPostPageList(
                        title: '작성한 게시물 목록',
                        postItemCount: _testPostItemList.length,
                        postItemList: _testPostItemList,
                        emptyMessage: '아직 작성한 게시물이 없어요.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildCoffeeChatRequestButton(),
          ],
          );
        }),
      ),
    );
  }

  Widget _buildOtherUserIntroductionSession(UserProfileDataModel? profile) {
    return Container(
      padding: AppPadding.button,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGap.v8,
          _buildOtherUserProfileInformation(profile),
          AppGap.v16,
          UserIntroductionText(bio: profile?.bio),
          AppGap.v24,
          const ProfileActivitySection(),
          AppGap.v24,
          ProfileInterestSection(
            interests: profile?.interests ?? [],
          ),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _buildOtherUserProfileInformation(UserProfileDataModel? profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => UserProfileImage(
            imageUrl: controller.profileImageUrl.value,
          ),
        ),
        UserNameAndMajor(
          name: profile?.displayName ?? '',
          major: profile?.major ?? '',
        ),
      ],
    );
  }

  Widget _buildCoffeeChatRequestButton() {
    return Container(
      padding: AppPadding.textField,
      color: AppColors.white,
      child: CustomButton(
        text: '커피챗 신청하기',
        variant: ButtonVariant.primary,
        onPressed: () => controller.createChatRoom(publicId),
      ),
    );
  }
}
