import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';

// bindings
import 'package:ondo/core/router/bindings/login_binding.dart';
import 'package:ondo/core/router/bindings/navigation_binding.dart';
import 'package:ondo/core/router/bindings/password_reset_binding.dart';
import 'package:ondo/core/router/bindings/signup_binding.dart';
import 'package:ondo/core/router/bindings/splash_binding.dart';

// controllers
import 'package:ondo/presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';

// password reset screens
import 'package:ondo/presentation/auth/password_reset/screens/password_reset_email_code_screen.dart';
import 'package:ondo/presentation/auth/password_reset/screens/password_reset_email_screen.dart';
import 'package:ondo/presentation/auth/password_reset/screens/password_reset_password_completed_screen.dart';
import 'package:ondo/presentation/auth/password_reset/screens/password_reset_password_screen.dart';

// signup screens
import 'package:ondo/presentation/auth/signup/screens/signup_email_code_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_email_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_introduction_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_major_interest_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_nickname_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_password_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_profile_image_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_complete_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_terms_agreement_screen.dart';

// auth / home
import 'package:ondo/presentation/auth/login/screens/login.dart';
import 'package:ondo/presentation/auth/login/screens/splash.dart';
import 'package:ondo/presentation/home/screens/home_screen.dart';

// navigation
import 'package:ondo/presentation/navigation/screens/navigation_screen.dart';

// profile
import 'package:ondo/presentation/profile/screens/edit_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/my_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/other_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/setting_screen.dart';
import 'package:ondo/presentation/profile/screens/terms_screen.dart';

class RoutePaths {
  static const String navigation = '/';
  static const String splash = '/splash';

  static const String home = '/home';
  static const String login = '/login';

  static const String passwordReset = '/password_reset';
  static const String passwordResetInputEmail = '/password_reset/email';
  static const String passwordResetInputEmailCode =
      '/password_reset/email-code';
  static const String passwordResetInputPassword = '/password_reset/password';
  static const String passwordResetComplete = '/password_reset/complete';

  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String profileSetting = '/profile/setting';
  static const String profileTerms = '/profile/setting/terms';
  static const String userProfile = 'user/profile';

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
        return SplashScreen();
      },
    ), //splash

    GoRoute(
      path: RoutePaths.navigation,
      name: 'navigation',
      builder: (context, state) {
        NavigationBinding().dependencies();
        return NavigationScreen();
      },
    ), //navigation

    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => HomeScreen(),
    ), //home

    GoRoute(
      path: RoutePaths.login,
      name: 'login',
      builder: (context, state) {
        LoginBinding().dependencies();
        return LoginScreen();
      },
    ), //login

    ShellRoute(
      builder: (context, state, child) {
        PasswordResetBinding().dependencies();
        return child;
      },
      redirect: (context, state) {
        if (!Get.isRegistered<PasswordResetFlowController>()) {
          PasswordResetBinding().dependencies();
        }

        final flowController = Get.find<PasswordResetFlowController>();
        final location = state.uri.path;

        final allowedPaths = {
          RoutePaths.passwordResetInputEmail,
          RoutePaths.passwordResetInputEmailCode,
        };

        if (!flowController.isEmailVerified &&
            !allowedPaths.contains(location)) {
          return RoutePaths.passwordResetInputEmail;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.passwordResetInputEmail,
          name: 'passwordResetInputEmail',
          builder: (context, state) => PasswordResetEmailInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetInputEmailCode,
          name: 'passwordResetInputEmailCode',
          builder: (context, state) => PasswordResetEmailCodeInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetInputPassword,
          name: 'passwordResetInputPassword',
          builder: (context, state) => PasswordResetPasswordScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetComplete,
          name: 'passwordResetComplete',
          builder: (context, state) => PasswordResetCompletedScreen(),
        ),
      ],
    ), // password_reset

    GoRoute(
      path: RoutePaths.profile,
      name: 'profile',
      builder: (context, state) => MyProfileScreen(),
      routes: [
        GoRoute(
          path: RoutePaths.editProfile,
          name: 'editProfile',
          builder: (context, state) => EditProfileScreen(),
        ),
        GoRoute(
          path: RoutePaths.profileSetting,
          name: 'profileSetting',
          builder: (context, state) => SettingScreen(),
          routes: [
            GoRoute(
              path: RoutePaths.profileTerms,
              name: 'profileTerms',
              builder: (context, state) => TermsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.userProfile,
          name: 'userProfile',
          builder: (context, state) => OtherProfileScreen(),
        ),
      ],
    ), //profile

    ShellRoute(
      builder: (context, state, child) {
        SignupBinding().dependencies();
        return child;
      },
      redirect: (context, state) {
        if (state.uri.toString() == RoutePaths.signup) {
          return RoutePaths.signupTerms;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.signupTerms,
          name: "signupTerms",
          builder: (context, state) => SignupTermsAgreementScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupEmail,
          name: "signupEmail",
          builder: (context, state) => SignupEmailInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupEmailCode,
          name: "signupEmailCode",
          builder: (context, state) => SignupEmailCodeInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupPassword,
          name: "signupPassword",
          builder: (context, state) => SignupPasswordSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupNickname,
          name: "signupNickname",
          builder: (context, state) => SignupNicknameSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupProfileImage,
          name: "signupProfileImage",
          builder: (context, state) => SignupProfileImageSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupIntroduction,
          name: "signupIntroduction",
          builder: (context, state) => SignupIntroductionInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupMajorInterest,
          name: "signupMajorInterest",
          builder: (context, state) => SignupMajorInterestSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupComplete,
          name: "signupComplete",
          builder: (context, state) => SignupCompleteScreen(),
        ),
      ],
    ), //signup
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다.'),
    ),
  ),
);
