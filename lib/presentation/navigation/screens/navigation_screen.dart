import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/bindings/login_binding.dart';
import '../../../core/router/bindings/navigation_binding.dart';
import '../../../data/network/constants/api_constants.dart';
import '../../../domain/usecases/auth/sign_in_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  LoginBinding().dependencies();

  //TODO : 임시 login 로직 삭제
  await Get.find<SignInUseCase>().call(
    loginId: ApiConstants.loginId,
    password: ApiConstants.loginPassword,
  );

  NavigationBinding().dependencies();

  runApp(
    MaterialApp.router(
      routerConfig: appRouter,
    ),
  );
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.child});

  final Widget child;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _lastIndex = 0;

  final Map<String, BottomNavigationBarItem> _tabs = {
    RoutePaths.home: BottomNavigationBarItem(
      icon: SvgPicture.asset(AppIcon.homeUnSelect.path),
      activeIcon: SvgPicture.asset(AppIcon.homeSelect.path),
      label: '홈',
    ),
    RoutePaths.community: BottomNavigationBarItem(
      icon: SvgPicture.asset(AppIcon.communityUnSelect.path),
      activeIcon: SvgPicture.asset(AppIcon.communitySelect.path),
      label: '커뮤니티',
    ),
    RoutePaths.chat: BottomNavigationBarItem(
      icon: SvgPicture.asset(AppIcon.chatUnSelect.path),
      activeIcon: SvgPicture.asset(AppIcon.chatSelect.path),
      label: '채팅',
    ),
    RoutePaths.profile: BottomNavigationBarItem(
      icon: SvgPicture.asset(AppIcon.userUnSelect.path),
      activeIcon: SvgPicture.asset(AppIcon.userSelect.path),
      label: '프로필',
    ),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 매 navigation내 page 이동 마다 path 게산
    final location = GoRouterState.of(context).uri.path;

    /// 해당 경로가 home, community, chat, profile로 시작하는 지 판단 이후, tab index 계산
    final currentIndex = _tabs.keys.toList().indexWhere(
      (tab) => location.startsWith(tab),
    );

    /// 인데스가 유효하면 tab 이동
    if (currentIndex >= 0) {
      _lastIndex = currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _lastIndex,
      onTap: (value) {
        context.go(_tabs.keys.elementAt(value));
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      selectedLabelStyle: AppTextStyles.caption(textColor: AppColors.primary),
      unselectedItemColor: AppColors.gray50,
      unselectedLabelStyle: AppTextStyles.caption(textColor: AppColors.gray50),
      backgroundColor: AppColors.white,
      elevation: 0,
      items: _tabs.values.toList(),
    );
  }
}
