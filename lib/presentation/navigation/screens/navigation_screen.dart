import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/router/bindings/login_binding.dart';
import 'package:ondo/core/router/bindings/navigation_binding.dart';
import 'package:ondo/data/network/constants/api_constants.dart';
import 'package:ondo/presentation/auth/login/controllers/login_controller.dart';
import 'package:ondo/presentation/chat/screens/chat_main_screen.dart';
import 'package:ondo/presentation/community/screens/community_main_screen.dart';
import 'package:ondo/presentation/home/screens/home_screen.dart';
import 'package:ondo/presentation/navigation/controllers/navigation_controller.dart';
import 'package:ondo/presentation/profile/screens/my_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  LoginBinding().dependencies();

  //TODO : 임시 login 로직 삭제
  final loginController = Get.find<LoginController>();
  loginController.emailController.text = ApiConstants.loginId;
  loginController.passwordController.text = ApiConstants.loginPassword;
  loginController.login();

  NavigationBinding().dependencies();

  runApp(
    MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) {
              return NavigationScreen();
            },
          ),
        ],
      ),
    ),
  );
}

class NavigationScreen extends GetView<NavigationController> {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [
      HomeScreen(),
      CommunityMainScreen(),
      ChatMainScreen(),
      MyProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        body: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChange,
          children: pageList,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context, controller),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    NavigationController controller,
  ) {
    return BottomNavigationBar(
      currentIndex: controller.currentIndex.value,
      onTap: (value) {
        controller.changeIndex(value);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      selectedLabelStyle: AppTextStyles.caption(textColor: AppColors.primary),
      unselectedItemColor: AppColors.gray50,
      unselectedLabelStyle: AppTextStyles.caption(textColor: AppColors.gray50),
      backgroundColor: AppColors.white,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcon.homeUnSelect.path),
          activeIcon: SvgPicture.asset(AppIcon.homeSelect.path),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcon.communityUnSelect.path),
          activeIcon: SvgPicture.asset(AppIcon.communitySelect.path),
          label: '커뮤니티',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcon.chatUnSelect.path),
          activeIcon: SvgPicture.asset(AppIcon.chatSelect.path),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcon.userUnSelect.path),
          activeIcon: SvgPicture.asset(AppIcon.userSelect.path),
          label: '프로필',
        ),
      ],
    );
  }
}
