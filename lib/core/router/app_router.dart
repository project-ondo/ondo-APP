import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// bindings
import 'package:ondo/core/router/bindings/login_binding.dart';
import 'package:ondo/core/router/bindings/post_binding.dart';
import 'package:ondo/core/router/bindings/splash_binding.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';
import 'package:ondo/presentation/notification/screens/notification_screen.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'bindings/navigation_binding.dart';

// password reset
import 'package:ondo/core/router/routers/password_reset_routes.dart';

//sign up
import 'package:ondo/core/router/routers/sign_up_routes.dart';

// auth / home
import 'package:ondo/presentation/auth/login/screens/login.dart';
import 'package:ondo/presentation/auth/login/screens/splash.dart';
import 'package:ondo/core/router/routers/home_routes.dart';

// navigation
import 'package:ondo/presentation/navigation/screens/navigation_screen.dart';

// post
import 'package:ondo/presentation/post/screens/post_detail_screen.dart';

// profile
import 'package:ondo/core/router/routers/profile_route.dart';

//chat
import 'package:ondo/core/router/routers/chat_routes.dart';

//community
import 'package:ondo/core/router/routers/community_routes.dart';

class RoutePaths {
  //splash
  static const String splash = '/splash';

  //home
  static const String home = '/home';
  static const String homeSearch = '/home/search';

  //login
  static const String login = '/login';

  //notification
  static const String notification = '/notification';

  //post
  static const String postDetail = '/post/:postId';

  //community
  static const String community = '/community';
  static const String communitySearch = '/community/search';

  //chat
  static const String chat = '/chat';
  static const String chatSearch = '/chat/search';
  static const String chatDetail = '/chat/:chatRoomId';

  //password
  static const String passwordReset = '/password_reset';
  static const String passwordResetInputEmail = '/password_reset/email';
  static const String passwordResetInputEmailCode =
      '/password_reset/email-code';
  static const String passwordResetInputPassword = '/password_reset/password';
  static const String passwordResetComplete = '/password_reset/complete';

  //profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String profileSetting = '/profile/setting';
  static const String profileTerms = '/profile/setting/terms';
  static const String userProfile = '/profile/user/:publicId';

  //sign up
  static const String signup = '/signup';
  static const String signupTerms = '/signup/terms';
  static const String signupEmail = '/signup/email';
  static const String signupEmailCode = '/signup/email-code';
  static const String signupPassword = '/signup/password';
  static const String signupNickname = '/signup/nickname';
  static const String signupProfileImage = '/signup/profile-image';
  static const String signupIntroduction = '/signup/introduction';
  static const String signupMajorInterest = '/signup/major-interest';
  static const String signupComplete = '/signup/complete';
}

final GoRouter appRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      name: 'splash',
      builder: (context, state) {
        SplashBinding().dependencies();
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.login,
      name: 'login',
      builder: (context, state) {
        LoginBinding().dependencies();
        return const LoginScreen();
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        if (!Get.isRegistered<UserSearchUseCase>()) {
          NavigationBinding().dependencies();
        }
        return NavigationScreen(
          child: child,
        );
      },
      routes: [
        ...HomeRoutes.routes,
        ...CommunityRoutes.routes,
        ...ChatRoutes.routes,
        ...ProfileRoute.routes,

        GoRoute(
          path: RoutePaths.notification,
          builder: (context, state) {
            return NotificationScreen();
          },
        ),

        GoRoute(
          path: RoutePaths.postDetail,
          builder: (context, state) {
            final postId = int.parse(state.pathParameters['postId']!);
            if (!Get.isRegistered<PostViewController>(tag: postId.toString())) {
              PostBinding(postId, state.extra as bool? ?? false).dependencies();
            }
            return PostDetailScreen(
              postId: postId,
            );
          },
          onExit: (context, state) {
            final postId = int.parse(state.pathParameters['postId']!);
            Get.delete<PostViewController>(tag: postId.toString(), force: true);
            return true;
          },
        ),
      ],
    ),

    ...PasswordResetRoutes.routes,

    ...SignupRoutes.routes,
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다.'),
    ),
  ),
);
