import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/presentation/auth/signup/controllers/email_code_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/email_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/introduction_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/major_interest_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/nickname_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/password_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/profile_image_setup_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/terms_agreement_controller.dart';
import 'package:ondo/presentation/auth/signup/screens/email_code_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/email_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/introduction_input_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/major_interest_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/nickname_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/password_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/profile_image_setup_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/signup_complete_screen.dart';
import 'package:ondo/presentation/auth/signup/screens/terms_agreement_screen.dart';
import 'package:ondo/presentation/home/screens/home_screen.dart';
import 'package:ondo/presentation/profile/screens/edit_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/my_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/other_profile_screen.dart';
import 'package:ondo/presentation/profile/screens/setting_screen.dart';
import 'package:ondo/presentation/profile/screens/terms_screen.dart';

class RoutePaths {
  static const String home = '/';
  static const String login = '/login';

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
  initialLocation: RoutePaths.profile,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => HomeScreen(),
    ), //home
    GoRoute(
      path: RoutePaths.login,
      name: 'login',
      builder: (context, state) => Scaffold(
        body: Text('로그인페이지'),
      ),
    ), //login
    GoRoute(
      path: RoutePaths.profile,
      name: 'profile',
      builder: (context, state) => MyProfileScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          name: 'editProfile',
          builder: (context, state) => EditProfileScreen(),
        ),
        GoRoute(
          path: 'setting',
          name: 'profileSetting',
          builder: (context, state) => SettingScreen(),
          routes: [
            GoRoute(
              path: 'terms',
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

    GoRoute(
      path: RoutePaths.signup,
      name: 'signup',
      redirect: (context, state) {
        Get.lazyPut(() => SignupFlowController());
        if (state.uri.toString() == RoutePaths.signup) {
          return RoutePaths.signupTerms;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'terms',
          name: "signupTerms",
          builder: (context, state) {
            if (!Get.isRegistered<SignupFlowController>()) {
              SignupBinding().dependencies();
            }
            return TermsAgreementScreen();
          },
        ),
        GoRoute(
          path: 'email',
          name: "signupEmail",
          builder: (context, state) => EmailInputScreen(),
        ),
        GoRoute(
          path: 'email-code',
          name: "signupEmailCode",
          builder: (context, state) => EmailCodeInputScreen(),
        ),
        GoRoute(
          path: 'password',
          name: "signupPassword",
          builder: (context, state) => PasswordSetupScreen(),
        ),
        GoRoute(
          path: 'nickname',
          name: "signupNickname",
          builder: (context, state) => NicknameSetupScreen(),
        ),
        GoRoute(
          path: 'profile-image',
          name: "signupProfileImage",
          builder: (context, state) => ProfileImageSetupScreen(),
        ),
        GoRoute(
          path: 'introduction',
          name: "signupIntroduction",
          builder: (context, state) => IntroductionInputScreen(),
        ),
        GoRoute(
          path: 'major-interest',
          name: "signupMajorInterest",
          builder: (context, state) => MajorInterestSetupScreen(),
        ),
        GoRoute(
          path: 'complete',
          name: "signupComplete",
          builder: (context, state) {
            return SignupCompleteScreen();
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(
        body: Center(
          child: Text('페이지르 찾을 수 없습니다.'),
        ),
      ),
);

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupFlowController>(() => SignupFlowController());

    Get.lazyPut<TermsAgreementController>(() => TermsAgreementController());
    Get.lazyPut<EmailInputController>(() => EmailInputController());
    Get.lazyPut<EmailCodeInputController>(() => EmailCodeInputController());
    Get.lazyPut<PasswordInputController>(() => PasswordInputController());
    Get.lazyPut<NicknameInputController>(() => NicknameInputController());
    Get.lazyPut<ProfileImageSetupController>(
      () => ProfileImageSetupController(),
    );
    Get.lazyPut<IntroductionInputController>(
      () => IntroductionInputController(),
    );
    Get.lazyPut<MajorInterestController>(() => MajorInterestController());
  }
}
