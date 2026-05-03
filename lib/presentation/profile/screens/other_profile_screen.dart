import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';
import 'package:ondo/presentation/profile/widget/profile_activity_section.dart';
import 'package:ondo/presentation/profile/widget/profile_indicator_post_page_list.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_section.dart';
import 'package:ondo/presentation/profile/widget/profile_rating_session.dart';
import 'package:ondo/presentation/profile/widget/user_introduction_text.dart';
import 'package:ondo/presentation/profile/widget/user_name_and_major.dart';
import 'package:ondo/presentation/profile/widget/user_profile_image.dart';
import 'package:ondo/presentation/profile/widget/user_report_popup.dart';

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

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PostItem> testPostItemList = mockPostData.map((data) {
      return PostItem(
        postId: data['postId'],
        skills: List<String>.from(data['skills']),
        title: data['title'],
        author: data['author'],
        bookmarks: data['bookmarks'],
        favorites: data['favorites'],
        createAt: DateTime.now().subtract(
          Duration(minutes: data['createMinutes']),
        ),
        isMy: false,
      );
    }).toList();

    return SafeArea(
      child: BaseScaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ColoredBox(
                      color: AppColors.white,
                      child: CustomBackButton(
                        moreOptions: true,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => const UserReportPopup(),
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
                    ),
                    _buildOtherUserIntroductionSession(),
                    ProfileRatingSession(),
                    ProfileIndicatorPostPageList(
                      title: '작성한 게시물 목록',
                      postItemCount: testPostItemList.length,
                      postItemList: testPostItemList,
                    ),
                  ],
                ),
              ),
            ),
            _buildCoffeeChatRequestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherUserIntroductionSession() {
    return Container(
      padding: AppPadding.button,
      color: AppColors.white,
      child: Column(
        children: [
          AppGap.v8,
          _buildOtherUserProfileInformation(),
          AppGap.v16,
          // TODO: 상대 프로필 API 연동 후 실제 데이터로 교체
          const UserIntroductionText(bio: null),
          AppGap.v24,
          const ProfileActivitySection(),
          AppGap.v24,
          const ProfileInterestSection(interests: []),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _buildOtherUserProfileInformation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // TODO: 상대 프로필 API 연동 후 실제 데이터로 교체
        const UserProfileImage(),
        const UserNameAndMajor(name: '', major: ''),
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
        onPressed: () => log('커피챗 신청하기'), // TODO: 커피챗 API 연동
      ),
    );
  }
}