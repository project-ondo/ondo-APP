import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_popup_menu_button.dart';
import 'package:ondo/core/design_system/components/post/post_item.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/widget/profile_activity_section.dart';
import 'package:ondo/presentation/profile/widget/profile_indicator_post_page_list.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_section.dart';
import 'package:ondo/presentation/profile/widget/profile_rating_session.dart';
import 'package:ondo/presentation/profile/widget/user_introduction_text.dart';
import 'package:ondo/presentation/profile/widget/user_logout_popup.dart';
import 'package:ondo/presentation/profile/widget/user_name_and_major.dart';
import 'package:ondo/presentation/profile/widget/user_profile_image.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyProfileScreen(),
    ),
  );
}

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

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserIntroductionSession(),
              ProfileRatingSession(),
              //작성한 게시물 목록
              ProfileIndicatorPostPageList(
                title: "작성한 게시물 목록",
                postItemCount: testPostItemList.length,
                postItemList: testPostItemList,
              ),
              //즐겨찾기한 게시물
              ProfileIndicatorPostPageList(
                title: "즐겨찾기한 게시물",
                postItemCount: testPostItemList.length,
                postItemList: testPostItemList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserIntroductionSession() {
    return Container(
      color: AppColors.white,
      padding: AppPadding.textField,
      child: Column(
        children: [
          _buildUserProfileIntroduction(),
          AppGap.v16,
          UserIntroductionText(),
          AppGap.v24,
          ProfileActivitySection(),
          AppGap.v24,
          ProfileInterestSection(),
        ],
      ),
    );
  }

  Widget _buildUserProfileIntroduction() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v12,
            UserProfileImage(),

            UserNameAndMajor(),
          ],
        ),
        _buildMenuPopupButton(),
      ],
    );
  }

  Widget _buildMenuPopupButton() {
    return CustomPopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => log("정보 수정하기"),
          padding: AppPadding.settingSession,
          child: Text(
            "정보 수정하기",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
        PopupMenuItem(
          onTap: () => UserLogoutPopup.userLogoutPopup(context),
          padding: AppPadding.settingSession,
          child: Text(
            "로그아웃",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
        PopupMenuItem(
          onTap: () => log("설정"),
          padding: AppPadding.settingSession,
          child: Text(
            "설정",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
      ],
    );
  }

}
