import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/widget/profile_activity_section.dart';
import 'package:ondo/presentation/profile/widget/profile_indicator_post_page_list.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_section.dart';
import 'package:ondo/presentation/profile/widget/profile_rating_session.dart';
import 'package:ondo/presentation/profile/widget/user_introduction_text.dart';
import 'package:ondo/presentation/profile/widget/user_name_and_major.dart';
import 'package:ondo/presentation/profile/widget/user_profile_image.dart';
import 'package:ondo/presentation/profile/widget/user_report_popup.dart';

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
  {
    "skills": ["Android", "Kotlin"],
    "title": "Coroutine 완전 정복",
    "author": "이서연",
    "bookmarks": 60,
    "favorites": 33,
    "createMinutes": 22,
  },
  {
    "skills": ["Backend", "Node.js"],
    "title": "REST API 설계 원칙",
    "author": "박지훈",
    "bookmarks": 18,
    "favorites": 7,
    "createMinutes": 8,
  },
  {
    "skills": ["Flutter", "Animation"],
    "title": "Custom Animation 만들기",
    "author": "최유진",
    "bookmarks": 90,
    "favorites": 55,
    "createMinutes": 40,
  },
  {
    "skills": ["Database", "MySQL"],
    "title": "인덱스 구조 이해하기",
    "author": "정도현",
    "bookmarks": 21,
    "favorites": 9,
    "createMinutes": 12,
  },
  {
    "skills": ["Clean Architecture"],
    "title": "Layered Architecture 설계",
    "author": "한지민",
    "bookmarks": 33,
    "favorites": 14,
    "createMinutes": 6,
  },
  {
    "skills": ["Flutter", "Riverpod"],
    "title": "Riverpod 실전 적용",
    "author": "오승현",
    "bookmarks": 77,
    "favorites": 44,
    "createMinutes": 30,
  },
  {
    "skills": ["Testing", "Unit Test"],
    "title": "Flutter 테스트 전략",
    "author": "윤서진",
    "bookmarks": 25,
    "favorites": 11,
    "createMinutes": 18,
  },
  {
    "skills": ["DevOps", "CI/CD"],
    "title": "GitHub Actions 자동화",
    "author": "강다은",
    "bookmarks": 50,
    "favorites": 23,
    "createMinutes": 27,
  },
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
  {
    "skills": ["Android", "Kotlin"],
    "title": "Coroutine 완전 정복",
    "author": "이서연",
    "bookmarks": 60,
    "favorites": 33,
    "createMinutes": 22,
  },
  {
    "skills": ["Backend", "Node.js"],
    "title": "REST API 설계 원칙",
    "author": "박지훈",
    "bookmarks": 18,
    "favorites": 7,
    "createMinutes": 8,
  },
  {
    "skills": ["Flutter", "Animation"],
    "title": "Custom Animation 만들기",
    "author": "최유진",
    "bookmarks": 90,
    "favorites": 55,
    "createMinutes": 40,
  },
  {
    "skills": ["Database", "MySQL"],
    "title": "인덱스 구조 이해하기",
    "author": "정도현",
    "bookmarks": 21,
    "favorites": 9,
    "createMinutes": 12,
  },
  {
    "skills": ["Clean Architecture"],
    "title": "Layered Architecture 설계",
    "author": "한지민",
    "bookmarks": 33,
    "favorites": 14,
    "createMinutes": 6,
  },
  {
    "skills": ["Flutter", "Riverpod"],
    "title": "Riverpod 실전 적용",
    "author": "오승현",
    "bookmarks": 77,
    "favorites": 44,
    "createMinutes": 30,
  },
  {
    "skills": ["Testing", "Unit Test"],
    "title": "Flutter 테스트 전략",
    "author": "윤서진",
    "bookmarks": 25,
    "favorites": 11,
    "createMinutes": 18,
  },
  {
    "skills": ["DevOps", "CI/CD"],
    "title": "GitHub Actions 자동화",
    "author": "강다은",
    "bookmarks": 50,
    "favorites": 23,
    "createMinutes": 27,
  },
];

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PostItem> testPostItemList = mockPostData.map((data) {
      return PostItem(
        skills: data["skills"],
        title: data["title"],
        author: data["author"],
        bookmarks: data["bookmarks"],
        favorites: data["favorites"],
        createMinutes: data["createMinutes"],
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
                              builder: (context) => UserReportPopup(),
                            ),
                            padding: AppPadding.settingSession,
                            child: Text(
                              "신고하기",
                              style: AppTextStyles.caption(
                                textColor: AppColors.gray90,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () => log("차단하기"),
                            padding: AppPadding.settingSession,
                            child: Text(
                              "차단하기",
                              style: AppTextStyles.caption(
                                textColor: AppColors.gray90,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //상대방 정보(프로필 이미지, 이름 전공등)
                    _buildOtherUserIntroductionSession(),
                    //상대방 평점 세션
                    ProfileRatingSession(),
                    //작성한 게시물 목록
                    ProfileIndicatorPostPageList(
                      title: "작성한 게시물 목록",
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
          UserIntroductionText(),
          AppGap.v24,
          ProfileActivitySection(),
          AppGap.v24,
          ProfileInterestSection(),
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
        UserProfileImage(),
        UserNameAndMajor(),
      ],
    );
  }

  Widget _buildCoffeeChatRequestButton() {
    return Container(
      padding: AppPadding.textField,
      color: AppColors.white,
      child: CustomButton(
        text: "커피챗 신청하기",
        variant: ButtonVariant.primary,
        onPressed: () => log("커피챗 신청하기"),
      ),
    );
  }
}
