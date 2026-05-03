import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_popup_menu_button.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/post/widgets/post_item.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';
import 'package:ondo/presentation/profile/widget/profile_activity_section.dart';
import 'package:ondo/presentation/profile/widget/profile_indicator_post_page_list.dart';
import 'package:ondo/presentation/profile/widget/profile_interest_section.dart';
import 'package:ondo/presentation/profile/widget/profile_rating_session.dart';
import 'package:ondo/presentation/profile/widget/user_delete_popup.dart';
import 'package:ondo/presentation/profile/widget/user_introduction_text.dart';
import 'package:ondo/presentation/profile/widget/user_logout_popup.dart';
import 'package:ondo/presentation/profile/widget/user_name_and_major.dart';
import 'package:ondo/presentation/profile/widget/user_profile_image.dart';

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

final List<PostItem> testPostItemList = mockPostData.map((data) {
  return PostItem(
    skills: List<String>.from(data['skills']),
    title: data['title'],
    author: data['author'],
    bookmarks: data['bookmarks'],
    favorites: data['favorites'],
    createAt: DateTime.now().subtract(
      Duration(minutes: data['createMinutes']),
    ),
  );
}).toList();

class MyProfileScreen extends GetView<MyProfileController> {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (controller.isLoading.value && controller.profile.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = controller.profile.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildUserIntroductionSession(context, profile),
                ProfileRatingSession(),
                ProfileIndicatorPostPageList(
                  title: '작성한 게시물 목록',
                  postItemCount: testPostItemList.length,
                  postItemList: testPostItemList,
                ),
                ProfileIndicatorPostPageList(
                  title: '즐겨찾기한 게시물',
                  postItemCount: testPostItemList.length,
                  postItemList: testPostItemList,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserIntroductionSession(BuildContext context, profile) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.textField,
      child: Column(
        children: [
          _buildUserProfileIntroduction(context, profile),
          AppGap.v16,
          UserIntroductionText(bio: profile?.bio),
          AppGap.v24,
          ProfileActivitySection(),
          AppGap.v24,
          ProfileInterestSection(
            interests: profile?.interests ?? [],
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileIntroduction(BuildContext context, profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v12,
            Obx(() => UserProfileImage(
              imageUrl: controller.profileImageUrl.value,
            )),
            UserNameAndMajor(
              name: profile?.displayName ?? '',
              major: profile?.major ?? '',
            ),
          ],
        ),
        _buildMenuPopupButton(context),
      ],
    );
  }

  Widget _buildMenuPopupButton(BuildContext context) {
    return CustomPopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => context.push(RoutePaths.editProfile),
          padding: AppPadding.settingSession,
          child: Text(
            '정보 수정하기',
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
        PopupMenuItem(
          onTap: () => UserLogoutPopup.userLogoutPopup(
            context,
            onLogout: () async {
              await controller.logout(context);
              if (context.mounted) context.go(RoutePaths.login);
            },
          ),
          padding: AppPadding.settingSession,
          child: Text(
            '로그아웃',
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
        PopupMenuItem(
          onTap: () => context.push(RoutePaths.profileSetting),
          padding: AppPadding.settingSession,
          child: Text(
            '설정',
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
        PopupMenuItem(
          onTap: () => UserDeletePopup.userDeletePopup(
            context,
            onDelete: () async {
              final success = await controller.deleteAccount();
              if (success && context.mounted) {
                context.go(RoutePaths.login);
              }
            },
          ),
          padding: AppPadding.settingSession,
          child: Text(
            '회원탈퇴',
            style: AppTextStyles.caption(textColor: AppColors.red),
          ),
        ),
      ],
    );
  }
}